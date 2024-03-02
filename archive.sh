#!/bin/bash

# manual setting
ARCHIVE_PATH="/root/old"

# constant
REGEX_PATTERN="^(.+)\.(.+)$"

# validate archive path
if [ ! -d "${ARCHIVE_PATH}"  ]; then
  echo "アーカイブパスが存在しません。シェル内の ARCHIVE_PATH を確認してください"
  exit 1
fi

# validate args
ARCHIVE_TARGET=$1
if [ ${#ARCHIVE_TARGET} -eq 0 ]; then
  echo "引数にアーカイブするファイルを指定してください"
  exit 1
fi
if [ ! -f "${ARCHIVE_TARGET}" ]; then
  echo "引数はファイルではないか、存在しません: ${ARCHIVE_TARGET}"
  exit 1
fi

# make archived filename
DATE_AREA=$(date +%Y-%m-%d)
ARCHIVE_FILENAME=$(basename "${ARCHIVE_TARGET}")
# PRE_FILENAME=$(echo "${ARCHIVE_FILENAME}"|sed -E "s:${REGEX_PATTERN}:\1:g")
PRE_FILENAME=${ARCHIVE_FILENAME%.*}
# EXTEND=$(echo "${ARCHIVE_FILENAME}"|sed -E "s:${REGEX_PATTERN}:\2:g")
EXTEND=${ARCHIVE_FILENAME##*.}
ARCHIVED_FILENAME="${PRE_FILENAME}_${DATE_AREA}.${EXTEND}"

if [ ${#ARCHIVED_FILENAME} -eq 0 ]; then
  echo "アーカイブ後のファイル名作成でエラーが発生しました"
  exit 1
fi

# exist archived
if [ -f "${ARCHIVE_PATH}/${ARCHIVED_FILENAME}" ]; then
  read -rp "すでにアーカイブ済みです。上書きしますか？[yes|no]" OVERRIDE
  if [ "${OVERRIDE}" = "no" ]; then
    echo "上書きをキャンセルしました。"
    exit 0
  elif [ "${OVERRIDE}" = "yes" ]; then
    echo "上書きします。"
  else
    echo "yes,no以外が入力されたのでキャンセルします。"
    exit 1
  fi
fi

# archive
cp "${ARCHIVE_TARGET}" "${ARCHIVE_PATH}/${ARCHIVED_FILENAME}"
ARCHIVE_RESULT=$?
echo "log: ${ARCHIVE_TARGET} to ${ARCHIVE_PATH}/${ARCHIVED_FILENAME}"

# result
if [ "${ARCHIVE_RESULT}" -ne 0 ]; then
  echo "アーカイブが失敗しました"
else
  echo "アーカイブ成功しました"
fi
