# Needed for message boxes
Add-Type -AssemblyName PresentationFramework
#
# Path to your Steam css directory, and the css filename
$css_path = "C:\Program Files (x86)\Steam\steamui\css"
$css_name = "chunk~2dcc5aaf7.css"
#
# Get the file contents
if (Test-Path $css_path\$css_name) {
  $css_input = Get-Content -Raw $css_path\$css_name
  #
  # Text to replace and replacement text, do not remove spaces!
  $str_whatsnew = "._17uEBe5Ri8TMsnfELvs8-N{box-sizing:border-box;padding-top:16px;padding-bottom:0px;padding-inline-start:24px;padding-inline-end:16px;position:relative;height:324px;overflow:hidden;background-image:linear-gradient(to top, #171d25 0%, #2d333c 80%)}"
  $str_nowhatsnew = "._17uEBe5Ri8TMsnfELvs8-N{display:none !important;                                                                                                                                                                                                    }"
  $str_addshelf = "._3SkuN_ykQuWGF94fclHdhJ{box-sizing:border-box;display:flex;color:#a9a9a9;font-size:14px;font-weight:100;letter-spacing:1px;transition-property:opacity;transition-duration:.21s;transition-timing-function:ease-in-out}"
  $str_noaddshelf = "._3SkuN_ykQuWGF94fclHdhJ{display:none !important;                                                                                                                                                                      }"
  $str_leftcolumn = "._9sPoVBFyE_vE87mnZJ5aB{flex-shrink:0;display:flex;flex-direction:row;min-width:256px;width:272px;max-width:min( 50%, 100% - 400px );position:relative}"
  $str_noleftcolumn = "._9sPoVBFyE_vE87mnZJ5aB{flex-shrink:0;display:none;flex-direction:row;min-width:256px;width:272px;max-width:min( 50%, 100% - 400px );position:relative}"
  #
  # Perform the replacements, if needed
  if ($css_input.Contains($str_whatsnew)) {
    #
    # Remove the last Replace() here if you want the left column
    $css_output = $css_input.Replace($str_whatsnew,$str_nowhatsnew).Replace($str_addshelf,$str_noaddshelf).Replace($str_leftcolumn,$str_noleftcolumn)
    #
    # Backup the original file and write the new one
    Move-Item $css_path\$css_name $css_path\$css_name.backup -Force
    Set-Content $css_path\$css_name -NoNewline -Value $css_output
    [System.Windows.MessageBox]::Show($css_name+" patched successfully, What's New removed.","Steam CSS Patcher")
  } else {
    [System.Windows.MessageBox]::Show($css_name+" already patched, or strings have changed.","Steam CSS Patcher")
  }
} else {
  [System.Windows.MessageBox]::Show($css_name+" not found. css name may have changed.","Steam CSS Patcher")
}

