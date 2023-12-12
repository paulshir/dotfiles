import {ifDevice, type DeviceIdentifier, type ToKeyCode, type FunctionKeyCode, toSetVar} from 'karabiner.ts';

/* eslint-disable @typescript-eslint/naming-convention */
export const ifBuiltInKeyboard = ifDevice({
	is_built_in_keyboard: true,
});

export const usAppleKeyboards: DeviceIdentifier[] = [{
	is_built_in_keyboard: true,
	is_keyboard: true,
	product_id: 632,
	vendor_id: 1452,
},
{
	is_built_in_keyboard: true,
	product_id: 4294970239,
}];

export const nonUsAppleKeyboards: DeviceIdentifier[] = [{
	is_built_in_keyboard: true,
	is_keyboard: true,
	product_id: 627,
	vendor_id: 1452,
},
{
	is_built_in_keyboard: true,
	is_keyboard: true,
	product_id: 832,
	vendor_id: 1452,
}];

export const appleKeyboards: DeviceIdentifier[] = [
	...usAppleKeyboards,
	...nonUsAppleKeyboards,
];
/* eslint-enable @typescript-eslint/naming-convention */

export const ifUsAppleKeyboard = ifDevice(usAppleKeyboards);
export const ifNonUsAppleKeyboard = ifDevice(nonUsAppleKeyboards);
export const ifAppleKeyboard = ifDevice(appleKeyboards);

export const fnKeys = [...Array(12).keys()].map(i => `f${i + 1}` as FunctionKeyCode);
export const fnAppKeys: ToKeyCode[] = [
	'display_brightness_decrement',
	'display_brightness_increment',
	'mission_control',
	'illumination_decrement',
	'illumination_increment',
	'f16',
	'rewind',
	'play_or_pause',
	'fastforward',
	'mute',
	'volume_decrement',
	'volume_increment',
];

export const hyperVarName = 'hyper_active';
export const activateHyper = toSetVar(hyperVarName, 1);
export const deactivateHyper = toSetVar(hyperVarName, 0);

