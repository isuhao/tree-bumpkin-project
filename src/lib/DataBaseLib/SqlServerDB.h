#pragma once

#include "ObjectDB.h"

class CSqlServerDB : public CObjectDB
{
public:
	CSqlServerDB();
	~CSqlServerDB();

public:
	///建立连接
	BOOL ConnectDB(_bstr_t strServer, _bstr_t strDatabaseName, _bstr_t strUID, _bstr_t strPwd, int iOptions /* = 0 */);

	///表操作
	BOOL RenameTable(_bstr_t strOldTableName, _bstr_t strNewTableName);

	///字段操作
	BOOL ModifyField(_bstr_t strTableName, _bstr_t strFieldsFormat);
	//检查表名是否存在
	bool CheckTableNameExist(_bstr_t bstrTableName);

	//备份和还原
	BOOL Backup(_bstr_t strFullPath);
	BOOL Restore(_bstr_t strFullPath);
};