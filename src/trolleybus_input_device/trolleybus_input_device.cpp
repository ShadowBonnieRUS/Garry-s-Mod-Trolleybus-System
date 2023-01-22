#include <windows.h>
#include <dinput.h>
#include <iostream>
#include <time.h>

#pragma comment(lib, "dinput8")
#pragma comment(lib, "dxguid")

#ifndef _DEBUG
#include "Lua/Interface.h"
#endif

#pragma region CPlusPlusCode

#define MAX_DEVICES 64
#define MAX_DEVICE_OBJECTS 64

#define DEVICEOBJECT_TYPE_X			0
#define DEVICEOBJECT_TYPE_Y			1
#define DEVICEOBJECT_TYPE_Z			2
#define DEVICEOBJECT_TYPE_RX		3
#define DEVICEOBJECT_TYPE_RY		4
#define DEVICEOBJECT_TYPE_RZ		5
#define DEVICEOBJECT_TYPE_Button	6

#ifdef _DEBUG
#define ASSERT(action) {HRESULT _r = action; if (_r != DI_OK) printf("%s failed! %i\n", #action, _r); }
#else
#define ASSERT(action) action;
#endif

LPDIRECTINPUT8 DInputInterface = NULL;

typedef LPDIRECTINPUTDEVICE8 pDevice;

struct DeviceObjectData {
	WCHAR name[MAX_PATH];
	unsigned int type = 0;

	LONG state = 0;
	unsigned int button = 0;
};

struct DeviceData {
	pDevice device;
	WCHAR name[MAX_PATH];
	DIJOYSTATE2 state = {};

	GUID guid;
	OLECHAR guidstr[MAX_PATH];

	DeviceObjectData objdata[MAX_DEVICE_OBJECTS];
	unsigned int objects = 0;
	unsigned int buttons = 0;

	clock_t lastupdate = 0;
	
	void UpdateState() {
		clock_t time = clock();
		if ((float)(time - lastupdate) / CLK_TCK < 0.05f) return;

		lastupdate = time;

		device->Poll();
		device->GetDeviceState(sizeof(DIJOYSTATE2), (LPVOID)&state);

		for (unsigned int i = 0; i < objects; i++) {
			DeviceObjectData* obj = &objdata[i];

			switch (obj->type)
			{
				case DEVICEOBJECT_TYPE_X: obj->state = state.lX; break;
				case DEVICEOBJECT_TYPE_Y: obj->state = state.lY; break;
				case DEVICEOBJECT_TYPE_Z: obj->state = state.lZ; break;
				case DEVICEOBJECT_TYPE_RX: obj->state = state.lRx; break;
				case DEVICEOBJECT_TYPE_RY: obj->state = state.lRy; break;
				case DEVICEOBJECT_TYPE_RZ: obj->state = state.lRz; break;
				case DEVICEOBJECT_TYPE_Button: obj->state = state.rgbButtons[obj->button] ? 1 : 0; break;
			}
		}
	}
};

DeviceData* Devices[MAX_DEVICES];
unsigned int DeviceCount = 0;
unsigned int DeviceUpdate = 0;

BOOL CALLBACK DeviceObjectCallback(LPCDIDEVICEOBJECTINSTANCE object, LPVOID param) {
	DeviceData* data = (DeviceData*)param;

#define AddObject(type) { DeviceObjectData* dt = &data->objdata[data->objects++]; dt->##ty##pe = type; wcscpy_s(dt->name, object->tszName); }

	if (object->guidType == GUID_XAxis) AddObject(DEVICEOBJECT_TYPE_X)
	else if (object->guidType == GUID_YAxis) AddObject(DEVICEOBJECT_TYPE_Y)
	else if (object->guidType == GUID_ZAxis) AddObject(DEVICEOBJECT_TYPE_Z)
	else if (object->guidType == GUID_RxAxis) AddObject(DEVICEOBJECT_TYPE_RX)
	else if (object->guidType == GUID_RyAxis) AddObject(DEVICEOBJECT_TYPE_RY)
	else if (object->guidType == GUID_RzAxis) AddObject(DEVICEOBJECT_TYPE_RZ)
	else if (object->guidType == GUID_Button) {
		DeviceObjectData* dt = &data->objdata[data->objects++];
		dt->type = DEVICEOBJECT_TYPE_Button;
		wcscpy_s(dt->name, object->tszName);
		dt->button = data->buttons++;
	}

#undef AddObject

	return DIENUM_CONTINUE;
}

BOOL CALLBACK DeviceCallback(LPCDIDEVICEINSTANCE instance, LPVOID param){
	pDevice device;

	HRESULT result = DInputInterface->CreateDevice(instance->guidInstance, &device, NULL);

	if (result == DI_OK) {
		DeviceData* data = new DeviceData;
		data->device = device;
		data->guid = instance->guidInstance;
		wcscpy_s(data->name, instance->tszProductName);

		StringFromGUID2(instance->guidInstance, data->guidstr, MAX_PATH);

		Devices[DeviceCount++] = data;

		ASSERT(device->SetDataFormat(&c_dfDIJoystick2));
		ASSERT(device->EnumObjects(DeviceObjectCallback, (LPVOID)data, NULL));
		ASSERT(device->Acquire());
	}

#ifdef _DEBUG

	else {
		printf("DInputInterface->CreateDevice(instance->guidInstance, &device, NULL) failed! %i\n", result);
	}

#endif

	return DIENUM_CONTINUE;
}

bool ClearDevices() {
	if (DInputInterface) {
		for (unsigned int i = 0; i < DeviceCount; i++) {
			DeviceData* data = Devices[i];
			ASSERT(data->device->Unacquire());

			delete data;
		}

		DInputInterface->Release();
		DInputInterface = NULL;

		DeviceCount = 0;
		DeviceUpdate++;

		return true;
	}

	return false;
}

bool SetupDevices() {
	ClearDevices();

	HRESULT result = DirectInput8Create(GetModuleHandle(NULL), DIRECTINPUT_VERSION, IID_IDirectInput8, (LPVOID*)(&DInputInterface), NULL);

	if (result == DI_OK) {
		DInputInterface->EnumDevices(DI8DEVCLASS_GAMECTRL, DeviceCallback, NULL, DIEDFL_ATTACHEDONLY);

		return true;
	}

#ifdef _DEBUG

	else {
		printf("DirectInput8Create(GetModuleHandle(NULL), DIRECTINPUT_VERSION, IID_IDirectInput8, (LPVOID*)(&DInputInterface), NULL) failed! %i\n", result);
	}

#endif

	return false;
}

#pragma endregion

#pragma region LuaCode

#ifdef _DEBUG
int main() {
	if (SetupDevices()) {
		while (true) {
			printf_s("Select device:\n");

			for (unsigned int i = 0; i < DeviceCount; i++) {
				wprintf_s(L"%i - %s %s\n", i, Devices[i]->name, Devices[i]->guidstr);
			}

			unsigned int idevice;
			std::cin >> idevice;

			if (idevice >= DeviceCount) continue;

			DeviceData* devicedata = Devices[idevice];

			while (true) {
				devicedata->UpdateState();

				for (unsigned int i = 0; i < devicedata->objects; i++) {
					DeviceObjectData* object = &devicedata->objdata[i];

					wprintf_s(L"%li -> %s\n", object->state, object->name);
				}

				Sleep(0.5);
			}
		}
	}
	else {
		printf("SetupDevices() failed!\n");
	}
}
#else
using namespace GarrysMod::Lua;

int lua_device_type, lua_device_object_type;

bool lua_IsDeviceDataValid(DeviceData* data) {
	if (data && DInputInterface) {
		HRESULT hr = data->device->Poll();

		if (hr == DI_OK || hr == DI_NOEFFECT)
			return true;
	}

	return false;
}

void wchar_to_char(ILuaBase* LUA, char* buffer, const wchar_t* str) {
	LUA->PushSpecial(SPECIAL_GLOB);
	LUA->GetField(-1, "utf8");
	LUA->GetField(-1, "char");

	unsigned int i = 0;

	while (true) {
		wchar_t ch = str[i];
		if (ch == '\0') break;

		LUA->PushNumber((double)(int)ch);
		i++;
	}

	LUA->Call(i, 1);

	const char* nstr = LUA->GetString(-1);
	strcpy_s(buffer, MAX_PATH, nstr);

	LUA->Pop(3);
}

class lua_Device {
public:

	DeviceData* data = NULL;
	unsigned int update = 0;

	lua_Device(DeviceData* dt) {
		data = dt;
		update = DeviceUpdate;
	}

	lua_Device(const lua_Device& device) {
		data = device.data;
		update = device.update;
	}

	inline bool IsValid() { return update == DeviceUpdate && lua_IsDeviceDataValid(data); }

	inline void GetName(ILuaBase* LUA, char* buffer) { wchar_to_char(LUA, buffer, data->name); }
	inline void GetGUID(ILuaBase* LUA, char* buffer) { wchar_to_char(LUA, buffer, data->guidstr); }
};

class lua_DeviceObject {
public:

	DeviceData* data = NULL;
	DeviceObjectData* odata = NULL;

	unsigned int update = 0;
	
	lua_DeviceObject(lua_Device* device, unsigned int object) {
		data = device->data;
		update = device->update;

		if (object < data->objects)
			odata = &data->objdata[object];
	}

	lua_DeviceObject(const lua_DeviceObject& obj) {
		data = obj.data;
		update = obj.update;
		odata = obj.odata;
	}

	inline bool IsValid() { return update == DeviceUpdate && odata && lua_IsDeviceDataValid(data); }
	inline bool IsButton() { return odata->type == DEVICEOBJECT_TYPE_Button; }

	inline void GetName(ILuaBase* LUA, char* buffer) { wchar_to_char(LUA, buffer, odata->name); }
	inline LONG GetState() { return odata->state; }
	inline bool GetButtonState() { return odata->state == 1; }
};

LUA_FUNCTION(lua_LoadDevices) {
	LUA->PushBool(SetupDevices());

	return 1;
}

LUA_FUNCTION(lua_UnloadDevices) {
	LUA->PushBool(ClearDevices());

	return 1;
}

LUA_FUNCTION(lua_GetDevices) {
	LUA->CreateTable();

	if (!DInputInterface) return 1;

	for (unsigned long long i = 0; i < DeviceCount; i++) {
		LUA->PushNumber(i + 1L);

		lua_Device device(Devices[i]);
		LUA->PushUserType_Value(device, lua_device_type);

		LUA->SetTable(-3);
	}

	return 1;
}

LUA_FUNCTION(lua_GetDeviceByGUID) {
	LUA->CheckType(1, Type::String);

	if (!DInputInterface) return 0;

	const char* guid = LUA->GetString(1);

	for (unsigned int i = 0; i < DeviceCount; i++) {
		unsigned int j = 0;

		while (true) {
			OLECHAR ch = Devices[i]->guidstr[j];
			if (ch != guid[j]) break;

			if (ch == '\0') {
				lua_Device device(Devices[i]);
				LUA->PushUserType_Value(device, lua_device_type);

				return 1;
			}

			j++;
		}
	}

	return 0;
}

LUA_FUNCTION(lua_device_IsValid) {
	LUA->CheckType(1, lua_device_type);

	lua_Device* device = LUA->GetUserType<lua_Device>(1, lua_device_type);
	LUA->PushBool(device->IsValid());

	return 1;
}

LUA_FUNCTION(lua_device_GetName) {
	LUA->CheckType(1, lua_device_type);

	lua_Device* device = LUA->GetUserType<lua_Device>(1, lua_device_type);
	if (!device->IsValid()) return 0;

	char name[MAX_PATH];
	device->GetName(LUA, name);

	LUA->PushString(name);

	return 1;
}

LUA_FUNCTION(lua_device_GetGUID) {
	LUA->CheckType(1, lua_device_type);

	lua_Device* device = LUA->GetUserType<lua_Device>(1, lua_device_type);
	if (!device->IsValid()) return 0;

	char guid[MAX_PATH];
	device->GetGUID(LUA, guid);

	LUA->PushString(guid);

	return 1;
}

LUA_FUNCTION(lua_device_GetAxles) {
	LUA->CheckType(1, lua_device_type);

	lua_Device* device = LUA->GetUserType<lua_Device>(1, lua_device_type);
	if (!device->IsValid()) return 0;

	LUA->CreateTable();

	unsigned int count = 0;
	for (unsigned long long i = 0; i < device->data->objects; i++) {
		if (device->data->objdata[i].type == DEVICEOBJECT_TYPE_Button) continue;

		LUA->PushNumber(++count);

		lua_DeviceObject object(device, i);
		LUA->PushUserType_Value(object, lua_device_object_type);

		LUA->SetTable(-3);
	}

	return 1;
}

LUA_FUNCTION(lua_device_GetButtons) {
	LUA->CheckType(1, lua_device_type);

	lua_Device* device = LUA->GetUserType<lua_Device>(1, lua_device_type);
	if (!device->IsValid()) return 0;

	LUA->CreateTable();

	unsigned int count = 0;
	for (unsigned long long i = 0; i < device->data->objects; i++) {
		if (device->data->objdata[i].type != DEVICEOBJECT_TYPE_Button) continue;

		LUA->PushNumber(++count);

		lua_DeviceObject object(device, i);
		LUA->PushUserType_Value(object, lua_device_object_type);

		LUA->SetTable(-3);
	}

	return 1;
}

LUA_FUNCTION(lua_device_tostring) {
	LUA->CheckType(1, lua_device_type);

	lua_Device* device = LUA->GetUserType<lua_Device>(1, lua_device_type);

	char string[MAX_PATH];

	if (device->IsValid()) {
		char name[MAX_PATH];
		device->GetName(LUA, name);

		char guid[MAX_PATH];
		device->GetGUID(LUA, guid);

		sprintf_s(string, "Trolleybus System Input Device (%s) %s", name, guid);
	}
	else
		sprintf_s(string, "Trolleybus System Input Device (NULL)");

	LUA->PushString(string);

	return 1;
}

LUA_FUNCTION(lua_device_object_GetName) {
	LUA->CheckType(1, lua_device_object_type);

	lua_DeviceObject* object = LUA->GetUserType<lua_DeviceObject>(1, lua_device_object_type);
	if (!object->IsValid()) return 0;

	char name[MAX_PATH];
	object->GetName(LUA, name);

	LUA->PushString(name);

	return 1;
}

LUA_FUNCTION(lua_device_object_GetState) {
	LUA->CheckType(1, lua_device_object_type);

	lua_DeviceObject* object = LUA->GetUserType<lua_DeviceObject>(1, lua_device_object_type);
	if (!object->IsValid()) return 0;

	object->data->UpdateState();
	LUA->PushNumber((double)object->GetState());

	return 1;
}

LUA_FUNCTION(lua_device_object_GetButtonState) {
	LUA->CheckType(1, lua_device_object_type);

	lua_DeviceObject* object = LUA->GetUserType<lua_DeviceObject>(1, lua_device_object_type);
	if (!object->IsValid() || !object->IsButton()) return 0;

	object->data->UpdateState();
	LUA->PushBool(object->GetButtonState());

	return 1;
}

LUA_FUNCTION(lua_device_object_IsValid) {
	LUA->CheckType(1, lua_device_object_type);

	lua_DeviceObject* object = LUA->GetUserType<lua_DeviceObject>(1, lua_device_object_type);
	LUA->PushBool(object->IsValid());

	return 1;
}

LUA_FUNCTION(lua_device_object_tostring) {
	LUA->CheckType(1, lua_device_object_type);

	lua_DeviceObject* object = LUA->GetUserType<lua_DeviceObject>(1, lua_device_object_type);

	char string[MAX_PATH];

	if (object->IsValid()) {
		char name[MAX_PATH];
		object->GetName(LUA, name);

		sprintf_s(string, "Trolleybus System Input Device Object (%s)", name);
	}
	else
		sprintf_s(string, "Trolleybus System Input Device Object (NULL)");

	LUA->PushString(string);

	return 1;
}

GMOD_MODULE_OPEN() {
	LUA->PushSpecial(SPECIAL_GLOB);

	LUA->GetField(-1, "Trolleybus_System");

	if (!LUA->IsType(-1, Type::Table)) {
		LUA->Pop(2);

		return 0;
	}

	LUA->CreateTable();

	LUA->PushCFunction(lua_LoadDevices);
	LUA->SetField(-2, "LoadDevices");

	LUA->PushCFunction(lua_UnloadDevices);
	LUA->SetField(-2, "UnloadDevices");

	LUA->PushCFunction(lua_GetDevices);
	LUA->SetField(-2, "GetDevices");

	LUA->PushCFunction(lua_GetDeviceByGUID);
	LUA->SetField(-2, "GetDeviceByGUID");

	LUA->SetField(-2, "_DeviceInputModule");
	LUA->Pop(2);

	lua_device_type = LUA->CreateMetaTable("TrollSysInputDevice");

	LUA->PushCFunction(lua_device_GetAxles);
	LUA->SetField(-2, "GetAxles");

	LUA->PushCFunction(lua_device_GetButtons);
	LUA->SetField(-2, "GetButtons");

	LUA->PushCFunction(lua_device_IsValid);
	LUA->SetField(-2, "IsValid");

	LUA->PushCFunction(lua_device_GetName);
	LUA->SetField(-2, "GetName");

	LUA->PushCFunction(lua_device_GetGUID);
	LUA->SetField(-2, "GetGUID");

	LUA->PushCFunction(lua_device_tostring);
	LUA->SetField(-2, "__tostring");

	LUA->Push(-1);
	LUA->SetField(-2, "__index");

	LUA->Pop();

	lua_device_object_type = LUA->CreateMetaTable("TrollSysInputDeviceObject");

	LUA->PushCFunction(lua_device_object_GetState);
	LUA->SetField(-2, "GetState");

	LUA->PushCFunction(lua_device_object_GetButtonState);
	LUA->SetField(-2, "GetButtonState");

	LUA->PushCFunction(lua_device_object_GetName);
	LUA->SetField(-2, "GetName");

	LUA->PushCFunction(lua_device_object_IsValid);
	LUA->SetField(-2, "IsValid");

	LUA->PushCFunction(lua_device_object_tostring);
	LUA->SetField(-2, "__tostring");

	LUA->Push(-1);
	LUA->SetField(-2, "__index");

	return 0;
}

GMOD_MODULE_CLOSE() {
	ClearDevices();

	return 0;
}

#endif

#pragma endregion