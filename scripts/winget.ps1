# Install winget packages

$essestials = (
    "Google.Chrome",
    "Microsoft.WindowsTerminal",
    "7zip.7zip",
    "Microsoft.VisualStudioCode"
)

$basic = (
    "LINE.LINE"
)

$development = (
    "SlackTechnologies.Slack"
)


# foreach ($n in $essestials) {
#     winget install --force $n
# }
foreach ($n in $basic) {
    winget install $n
}
foreach ($n in $development) {
    winget install $n
}

