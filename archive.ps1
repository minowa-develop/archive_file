# manual setting
$ARCHIVE_PATH = "\Users\user\tools\archive_tool\old"

# validate archive path
if (-not (Test-Path -Path $ARCHIVE_PATH)) {
  Write-Host "アーカイブパスが存在しません。シェル内の ARCHIVE_PATH を確認してください"
  exit 1
}

# validate args
$ARCHIVE_TARGET = $args[0]
if ($ARCHIVE_TARGET.Length -eq 0) {
  Write-Host "引数にアーカイブするファイルを指定してください"
  exit 1
}
if (-not (Test-Path -Path $ARCHIVE_TARGET)) {
  Write-Host "存在しません: $ARCHIVE_TARGET"
  exit 1
}
if ((Get-Item $ARCHIVE_TARGET).PSIsContainer) {
  Write-Host "指定されたパスはフォルダです。"
  exit 1
}

# make archived filename
$DATE_AREA = Get-Date -Format "yyyy-MM-dd"
$ARCHIVE_FILENAME = [System.IO.Path]::GetFileName($ARCHIVE_TARGET)
$PRE_FILENAME = [System.IO.Path]::GetFileNameWithoutExtension($ARCHIVE_FILENAME)
$EXTEND = [System.IO.Path]::GetExtension($ARCHIVE_FILENAME)
$ARCHIVED_FILENAME = "${PRE_FILENAME}_${DATE_AREA}${EXTEND}"

if ($ARCHIVED_FILENAME.Length -eq 0) {
  Write-Host "アーカイブ後のファイル名作成でエラーが発生しました"
  exit 1
}

# exist archived
if (Test-Path -Path "$ARCHIVE_PATH\$ARCHIVED_FILENAME") {
  $OVERRIDE = Read-Host "すでにアーカイブ済みです。上書きしますか？[yes|no]"
  if ($OVERRIDE -eq "no") {
    Write-Host "上書きをキャンセルしました。"
    exit 0
  }
  elseif ($OVERRIDE -eq "yes") {
    Write-Host "上書きします。"
  }
  else {
    Write-Host "yes,no以外が入力されたのでキャンセルします。"
    exit 1
  }
}

# archive
Copy-Item -Path $ARCHIVE_TARGET -Destination "$ARCHIVE_PATH\$ARCHIVED_FILENAME"
$ARCHIVE_RESULT = $LASTEXITCODE
Write-Host "log: $ARCHIVE_TARGET to $ARCHIVE_PATH\$ARCHIVED_FILENAME"

# result
if ($ARCHIVE_RESULT -gt 0) {
  Write-Host "アーカイブが失敗しました: $ARCHIVE_RESULT"
  Write-Host "正常にコピーできているのに失敗している場合は管理者権限で実行されていない場合があります"
} else {
  Write-Host "アーカイブ成功しました"
}
