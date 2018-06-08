# Powershell tools

This is repo for my PowerShell scripts. So they are not going to be lost over time :)

Feel free to add issue/idea/feedback.

## Folder [Git](Git)

|Script name|Description|Parameters|
|-|-|-|
|[Url](Git/Url.ps1)|This script loops trought all children folders and creates list of all git remote URL's.|**searchDir**: the root directory for all your repositories, **outputDir**: here will be created your report, **addHeader**: Header can be disabled by passing false
|[AutoPush](Git/AutoPush.ps1)|Executes Git status commit & push.|**root**: Repository folder|
|[CloneClipboard](Git/CloneClipboard.ps1)|Clones git repository from the current clipboard value|**root**: Repository will be cloned to this directory|
|[OpenOriginUrl](Git/OpenOriginUrl.ps1)|The first value from git remove -v will be opened in web-browser|**root**: Directory within your repository, **browser**: you can specifie your browser|
|[PullAll](Git/PullAll.ps1)|This script loops trought all children folders and executes git pull --all.|**root**: Directory within your repository|
|[ChangeNameEmail](Git/ChangeNameEmail.ps1)|Change user.email or/and user.name in the current repository|**root**: Directory within your repository, **userName**: new user name, **userEmail** new user email|

## Folder [Shared](Shared)

|Script name|Description|Parameters|
|-|-|-|
|[Logger](Shared/Logger.ps1)|Simple console and file logger|**Message**: Message is the content that you wish to add to the log file., **Path**: The path to the log file to which you would like to write. By default the function will create the path and file if it does not exist. **Level**: Specify the criticality of the log information being written to the log (i.e. Error, Warning, Informational)|
