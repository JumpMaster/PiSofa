#include "pebble.h"

#define SOFA_MENU_SECTIONS 1
#define SOFA_MENU_ITEMS 5

#define POSITION_MENU_SECTIONS 1
#define POSITION_MENU_ITEMS 3
	
static Window *window;
static Window *position_window;

// This is a simple menu layer
static SimpleMenuLayer *sofa_menu_layer;
static SimpleMenuLayer *position_menu_layer;

// A simple menu layer can have multiple sections
static SimpleMenuSection sofa_menu_sections[SOFA_MENU_SECTIONS];
static SimpleMenuSection position_sofa_menu_sections[POSITION_MENU_SECTIONS];

// Each section is composed of a number of menu items
static SimpleMenuItem first_menu_items[SOFA_MENU_ITEMS];
static SimpleMenuItem first_menu_items2[POSITION_MENU_ITEMS];

static int selectedSofa;
static int selectedPos;

static uint8_t sync_buffer[64];
static AppSync sync;


static void send_cmd(void) {
	DictionaryIterator *iter;
	app_message_outbox_begin(&iter);
	
	if (iter == NULL) {
		APP_LOG(APP_LOG_LEVEL_DEBUG, "App Message Dropped!");
		return;
	}
	
	Tuplet sofapos_tuple = TupletInteger(0, selectedSofa);
	Tuplet sofamov_tuple = TupletInteger(1, selectedPos);
	
	dict_write_tuplet(iter, &sofapos_tuple);
	dict_write_tuplet(iter, &sofamov_tuple);
	dict_write_end(iter);

	app_message_outbox_send();
	
	APP_LOG(APP_LOG_LEVEL_DEBUG, "App Message Sent!");
}

static void app_message_init(void) {
	const uint32_t inbound_size = 64;
	const uint32_t outbound_size = 64;
	app_message_open(inbound_size, outbound_size);
	APP_LOG(APP_LOG_LEVEL_DEBUG, "App Message Init!");
}

// You can capture when the user selects a menu icon with a menu item select callback
static void sofa_select_callback(int index, void *ctx) {
	selectedSofa = index;
	if (selectedSofa == 4)
	{
		selectedPos = 3;
		send_cmd();
	} else {
		window_stack_push(position_window, true /* Animated */);
	}
}

static void position_select_callback(int index, void *ctx) {
	selectedPos = index;	
	send_cmd();
	window_stack_pop(true);
}

// This initializes the menu upon window load
static void window_load(Window *window) {

  int num_a_items = 0;

  // This is an example of how you'd set a simple menu item
  first_menu_items[num_a_items++] = (SimpleMenuItem){
    .title = "All Sofas",
    .callback = sofa_select_callback,
  };

  first_menu_items[num_a_items++] = (SimpleMenuItem){
    .title = "Sofa 1 (Left)",
    .callback = sofa_select_callback,
  };
  first_menu_items[num_a_items++] = (SimpleMenuItem){
    .title = "Sofa 2 (Middle)",
    .callback = sofa_select_callback,
  };
  first_menu_items[num_a_items++] = (SimpleMenuItem){
    .title = "Sofa 3 (Right)",
    .callback = sofa_select_callback,
  };
  first_menu_items[num_a_items++] = (SimpleMenuItem){
    .title = "Parental Mode",
    .callback = sofa_select_callback,
  };

  // Bind the menu items to the corresponding menu sections
  sofa_menu_sections[0] = (SimpleMenuSection){
    .num_items = SOFA_MENU_ITEMS,
    .items = first_menu_items,
  };

  // Now we prepare to initialize the simple menu layer
  // We need the bounds to specify the simple menu layer's viewport size
  // In this case, it'll be the same as the window's
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_frame(window_layer);

  // Initialize the simple menu layer
  sofa_menu_layer = simple_menu_layer_create(bounds, window, sofa_menu_sections, SOFA_MENU_SECTIONS, NULL);
  
  // Add it to the window for display
  layer_add_child(window_layer, simple_menu_layer_get_layer(sofa_menu_layer));
}

static void position_window_load(Window *window) {

  int num_a_items = 0;

  first_menu_items2[num_a_items++] = (SimpleMenuItem){
    .title = "Upright",
    .callback = position_select_callback,
  };
  // The menu items appear in the order saved in the menu items array
  first_menu_items2[num_a_items++] = (SimpleMenuItem){
    .title = "Feet Up",
    .callback = position_select_callback,
  };
  first_menu_items2[num_a_items++] = (SimpleMenuItem){
    .title = "Flat",
    .callback = position_select_callback,
  };

  // Bind the menu items to the corresponding menu sections
  position_sofa_menu_sections[0] = (SimpleMenuSection){
    .num_items = POSITION_MENU_ITEMS,
    .items = first_menu_items2,
  };

  // Now we prepare to initialize the simple menu layer
  // We need the bounds to specify the simple menu layer's viewport size
  // In this case, it'll be the same as the window's
  Layer *window_layer = window_get_root_layer(position_window);
  GRect bounds = layer_get_frame(window_layer);

  // Initialize the simple menu layer
  position_menu_layer = simple_menu_layer_create(bounds, position_window, position_sofa_menu_sections, POSITION_MENU_SECTIONS, NULL);
  
  // Add it to the window for display
  layer_add_child(window_layer, simple_menu_layer_get_layer(position_menu_layer));
}

// Deinitialize resources on window unload that were initialized on window load
void window_unload(Window *window) {
  simple_menu_layer_destroy(sofa_menu_layer);
}

void position_window_unload(Window *window) {
	simple_menu_layer_destroy(position_menu_layer);
}

static void init(void) {
	window = window_create();
	position_window = window_create();
	
	app_message_init();
	
	// Setup the window handlers
	window_set_window_handlers(window, (WindowHandlers) {
		.load = window_load,
		.unload = window_unload,
	});
	
	window_set_window_handlers(position_window, (WindowHandlers) {
		.load = position_window_load,
		.unload = position_window_unload,
	});
	
	window_stack_push(window, true /* Animated */);
}

static void deinit(void) {
	window_destroy(position_window);
	window_destroy(window);
}

int main(void) {
	init();
	APP_LOG(APP_LOG_LEVEL_DEBUG, "Done initializing, pushed window: %p", window);
	app_event_loop();
	deinit();
}