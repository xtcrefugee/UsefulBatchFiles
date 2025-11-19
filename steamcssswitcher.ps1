# Needed for message boxes
Add-Type -AssemblyName PresentationFramework
#
# Path to your Steam css directory, and the css filename
$css_path = "C:\Program Files (x86)\Steam\steamui\css"
$css_name = "chunk~2dcc5aaf7.css"
#
if ((Test-Path $css_path\$css_name) -And (Test-Path $css_path\$css_name.backup)) {
  $result = ""
  if (!(Test-Path $css_path\$css_name.modded)) {
    Copy-Item $css_path\$css_name $css_path\$css_name.modded -Force
    $result = "Created .modded backup file.`n"
  }
  if ((Get-FileHash $css_path\$css_name).Hash -eq (Get-FileHash $css_path\$css_name.modded).Hash) {
    Copy-Item $css_path\$css_name.backup $css_path\$css_name -Force
    $result = $result+"Now using original css.`n"
  } else {
    if ((Get-FileHash $css_path\$css_name).Hash -eq (Get-FileHash $css_path\$css_name.backup).Hash) {
      Copy-Item $css_path\$css_name.modded $css_path\$css_name -Force
      $result = $result+"Now using modded css.`n"
    } else {
      Copy-Item $css_path\$css_name $css_path\$css_name.modded -Force
      $result = $result+"Updated .modded backup file.`n"
      Copy-Item $css_path\$css_name.backup $css_path\$css_name -Force
      $result = $result+"Now using original css.`n"
    }
  }
  [System.Windows.MessageBox]::Show($result,"Steam CSS Switcher")
} else {
  [System.Windows.MessageBox]::Show("The Steam css file or its backup could not be found.`nPlease run the patcher first to generate the backup file.","Steam CSS Switcher")
}