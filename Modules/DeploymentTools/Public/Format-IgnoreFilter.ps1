function Format-IgnoreFilter{
    param (
		[ValidateNotNullOrEmpty()]
        [string[]]$FilterContent
    )
    $result = @();

    foreach ($filter in $FilterContent) {
        if ($filter.StartsWith('*')) {
                $result += "{0}{1}" -f '.', $filter 
            }
            else {
                $result = $filter
        }
    }
    return $result;
}