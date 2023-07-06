import {ifDevice, type DeviceIdentifier, type ToKeyCode, type FunctionKeyCode} from 'karabiner.ts';

/* eslint-disable @typescript-eslint/naming-convention */
export const ifAppleVendor = ifDevice({
	vendor_id: 1452,
});

export const usAppleKeyboards: DeviceIdentifier[] = [{
	product_id: 632,
	vendor_id: 1452,
}];

export const nonUsAppleKeyboards: DeviceIdentifier[] = [{
	product_id: 627,
	vendor_id: 1452,
},
{
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
	'launchpad',
	'illumination_decrement',
	'illumination_increment',
	'rewind',
	'play_or_pause',
	'fastforward',
	'mute',
	'volume_decrement',
	'volume_increment',
];
