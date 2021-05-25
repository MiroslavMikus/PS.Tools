# Invoke-Pester -Output Detailed .\CommentXml.Tests.ps1
BeforeAll {
    . ".\CommentXml.ps1"
}

Describe 'comment-xmlLine' {
    It "Comments out xml code" {
        $result = comment-xmlLine "test"
        $result | Should -Be "<!--test-->"
    }
}

Describe 'unComment-xmlLine' {
    It "Comments in xml code" {
        $result = unComment-xmlLine "<!--test-->"
        $result | Should -Be "test"
    }
}

Describe 'Recognize-CommentToken' {
    It "Missing token should be resognized" {
        $result = Recognize-CommentToken "<PackageReference Include=`"MassTransit`" Version=`"7.1.7`" />"
        $result | Should -BeFalse
    }

    It "Existing token should be resognized" {
        $result = Recognize-CommentToken "<PackageReference Include=`"MassTransit`" Version=`"7.1.7`" /> <!--[switch]-->"
        $result | Should -BeTrue
    }
}

Describe 'Replace-Token' {
    It "Should not change result if there is no token" {
        $actual = "<PackageReference Include=`"MassTransit`" Version=`"7.1.7`" />"
        $result = Replace-Token "<PackageReference Include=`"MassTransit`" Version=`"7.1.7`" />"
        $result | Should -Be $actual
    }

    It "Should replace Token" {
        $replaceDict = @{"[someToken]" = "someValue" };
        $actual = "<PackageReference Include=`"[someToken]`" Version=`"7.1.7`" /> <!--[switch]-->"
        $expected = "<PackageReference Include=`"someValue`" Version=`"7.1.7`" /> <!--[switch]-->"

        $result = Replace-Token $actual $replaceDict
        $result | Should -Be $expected
    }
    
    It "Should replace multiple Tokens" {
        $replaceDict = @{"[someToken]" = "someValue"; "[secondToken]" = "secondValue" };

        $actual = "<PackageReference [secondToken]=`"[someToken]`" Version=`"7.1.7`" /> <!--[switch]-->"
        $expected = "<PackageReference secondValue=`"someValue`" Version=`"7.1.7`" /> <!--[switch]-->"

        $result = Replace-Token $actual $replaceDict
        $result | Should -Be $expected
    }
}

Describe 'Toggle-Comment' {
    It 'Shold ignore line' {
        $actual = "<PackageReference [secondToken]=`"[someToken]`" Version=`"7.1.7`" />"

        $result = Toggle-Comment $actual
        $result | Should -Be $actual
    }

    It 'Sould comment in' {
        $actual = "<PackageReference [secondToken]=`"[someToken]`" Version=`"7.1.7`" /> <!--[switch]-->"
        $expected = "<!--<PackageReference [secondToken]=`"[someToken]`" Version=`"7.1.7`" /> [switch]-->"

        $result = Toggle-Comment $actual
        $result | Should -Be $expected
    }
    It 'Shold comment out' {
        $actual = "<PackageReference [secondToken]=`"[someToken]`" Version=`"7.1.7`" /> <!--[switch]-->"
        $expected = "<!--<PackageReference [secondToken]=`"[someToken]`" Version=`"7.1.7`" /> [switch]-->"

        $result = Toggle-Comment $actual
        $result | Should -Be $expected
    }
}


Describe 'NuGet-SwitchXml' {

    It 'Should produce expected result' {
        
        $actual = @"
<Project Sdk="Microsoft.NET.Sdk">

    <ItemGroup>
        <PackageReference Include="Newtonsoft.Json" Version="13.0.1" />
        <!--<PackageReference Include="SomeNuget" Version="13.0.1" />[switch]-->
    </ItemGroup>

    <ItemGroup><!--[switch]-->
        <Reference Include="ScaliRo.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"><!--[switch]-->
            <HintPath>[basePath]\Shared\ScaliRo.Shared\bin\Debug\net5.0\ScaliRo.Shared.dll</HintPath><!--[switch]-->
        </Reference><!--[switch]-->
    </ItemGroup><!--[switch]-->

</Project>
"@
        
        $expected = @"
<Project Sdk="Microsoft.NET.Sdk">

    <ItemGroup>
        <PackageReference Include="Newtonsoft.Json" Version="13.0.1" />
        <PackageReference Include="SomeNuget" Version="13.0.1" /><!--[switch]-->
    </ItemGroup>

<!--    <ItemGroup>[switch]-->
<!--        <Reference Include="ScaliRo.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">[switch]-->
<!--            <HintPath>C:\test\Shared\ScaliRo.Shared\bin\Debug\net5.0\ScaliRo.Shared.dll</HintPath>[switch]-->
<!--        </Reference>[switch]-->
<!--    </ItemGroup>[switch]-->

</Project>
"@

        $dict = @{"[basePath]"="C:\test"}
        $result = NuGet-SwitchXml $actual $dict
        $actual
        $result | Should -Be $expected
    }

    It 'Should produce inverted expected result' {
        $actual = @"
<Project Sdk="Microsoft.NET.Sdk">

    <ItemGroup>
        <PackageReference Include="Newtonsoft.Json" Version="13.0.1" />
<!--    <PackageReference Include="SomeNuget" Version="13.0.1" />[switch]-->
    </ItemGroup>

    <ItemGroup><!--[switch]-->
        <Reference Include="ScaliRo.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"><!--[switch]-->
            <HintPath>[basePath]\Shared\ScaliRo.Shared\bin\Debug\net5.0\ScaliRo.Shared.dll</HintPath><!--[switch]-->
        </Reference><!--[switch]-->
    </ItemGroup><!--[switch]-->

</Project>
"@
        
        $expected = @"
<Project Sdk="Microsoft.NET.Sdk">

    <ItemGroup>
        <PackageReference Include="Newtonsoft.Json" Version="13.0.1" />
    <PackageReference Include="SomeNuget" Version="13.0.1" /><!--[switch]-->
    </ItemGroup>

<!--    <ItemGroup>[switch]-->
<!--        <Reference Include="ScaliRo.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">[switch]-->
<!--            <HintPath>C:\test\Shared\ScaliRo.Shared\bin\Debug\net5.0\ScaliRo.Shared.dll</HintPath>[switch]-->
<!--        </Reference>[switch]-->
<!--    </ItemGroup>[switch]-->

</Project>
"@
        $dict = @{"C:\test"="[basePath]"}

        $result = NuGet-SwitchXml $expected $dict
        $result | Should -Be $actual
    }
}

# Describe 'NuGet-SwitchFile'{
#     It 'Should process multiple files' {
#         $projects = Get-ChildItem -Filter "*.csproj" -Recurse | `
#             Select-Object -ExpandProperty FullName 

#         $dict = @{"[basePath]"="C:\test"}

#         NuGet-SwitchFile -Projects $projects -ReplaceDictionary $dict
#     }
# }

# Describe 'NuGet-SwitchFile2'{
#     It 'Should process multiple files' {

#         $dict = @{"[basePath]"="C:\test"}

#         NuGet-SwitchFile -rootDir "." -replaceDictionary $dict 
#     }
# }

# Describe 'NuGet-SwitchFile revert'{
#     It 'Should process multiple files' {
#         $projects = Get-ChildItem -Filter "*.csproj" -Recurse | `
#             Select-Object -ExpandProperty FullName 

#         $dict = @{"C:\test"="[basePath]"}

#         NuGet-SwitchFile -Projects $projects -ReplaceDictionary $dict
#     }
# }