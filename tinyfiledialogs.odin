package tinyfiledialogs;
foreign import tfd "external/tinyfiledialogs.a";

import "core:strings"

@(default_calling_convention="c")
foreign tfd {
	tinyfd_messageBox 		:: proc (title: cstring, message: cstring, dialog_type: cstring, icon_type: cstring, default_button: int) -> int ---;
	tinyfd_inputBox 		:: proc (title: cstring, message: cstring, default_input: cstring) -> cstring ---;
	tinyfd_saveFileDialog 	:: proc (title: cstring, default_path_and_file: cstring, num_filters: int, filters: ^cstring, filter_desc: cstring) -> cstring ---;
	tinyfd_openFileDialog 	:: proc (title: cstring, default_path_and_file: cstring, num_filters: int, filters: ^cstring, filter_desc: cstring, allow_multiple_select: int) -> cstring ---;
}

message_box		:: proc (title, message, dialog_type, icon_type: string, default_button: int) -> int {
	ttl := strings.clone_to_cstring(title, context.temp_allocator);
	msg := strings.clone_to_cstring(message, context.temp_allocator);
	dtype := strings.clone_to_cstring(dialog_type, context.temp_allocator);
	itype := strings.clone_to_cstring(icon_type, context.temp_allocator);
	
	return tinyfd_messageBox(ttl, msg, dtype, itype, default_button);
}

// Returns a odin-string, needs to be freed
input_box		:: proc (title, message, default_input: string) -> string {
	ttl := strings.clone_to_cstring(title, context.temp_allocator);
	msg := strings.clone_to_cstring(message, context.temp_allocator);
	dinput := strings.clone_to_cstring(default_input, context.temp_allocator);
	
	return string(tinyfd_inputBox(ttl, msg, dinput));
}

save_file_dialog :: proc (title, default_path_and_file : string, num_filters: int, filters: []string, filter_desc: string) -> string {
	ttl := strings.clone_to_cstring(title, context.temp_allocator);
	def := strings.clone_to_cstring(default_path_and_file, context.temp_allocator);

	fls : [dynamic]cstring;
	for i in 0..num_filters-1 {
		append(&fls, strings.clone_to_cstring(filters[i], context.temp_allocator));
	}
	
	fdesc := strings.clone_to_cstring(filter_desc, context.temp_allocator);
	return strings.clone(string(tinyfd_saveFileDialog(ttl, def, num_filters, &fls[0], fdesc)));
}

open_file_dialog :: proc (title, default_path_and_file : string, num_filters: int, filters : []string, filter_desc: string, allow_multiple_select: int) -> string {
	ttl := strings.clone_to_cstring(title, context.temp_allocator);
	def := strings.clone_to_cstring(default_path_and_file, context.temp_allocator);
	fls : [dynamic]cstring;
	for i in 0..num_filters-1 {
		append(&fls, strings.clone_to_cstring(filters[i], context.temp_allocator));
	}
	fdesc := strings.clone_to_cstring(filter_desc, context.temp_allocator);
	return strings.clone(string(tinyfd_openFileDialog(ttl, def, num_filters, &fls[0], fdesc, allow_multiple_select)));
}
