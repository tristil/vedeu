require 'test_helper'

module Vedeu

  describe Bindings do

    context 'the system events needed by Vedeu to run are defined' do
      it { Vedeu.events.registered?(:_clear_).must_equal(true) }
      it { Vedeu.events.registered?(:_clear_group_).must_equal(true) }
      it { Vedeu.events.registered?(:_cleanup_).must_equal(true) }
      it { Vedeu.events.registered?(:_command_).must_equal(true) }
      it { Vedeu.events.registered?(:_exit_).must_equal(true) }
      it { Vedeu.events.registered?(:_hide_group_).must_equal(true) }
      it { Vedeu.events.registered?(:_initialize_).must_equal(true) }
      it { Vedeu.events.registered?(:_keypress_).must_equal(true) }
      it { Vedeu.events.registered?(:_log_).must_equal(true) }
      it { Vedeu.events.registered?(:_mode_switch_).must_equal(true) }
      it { Vedeu.events.registered?(:_refresh_).must_equal(true) }
      it { Vedeu.events.registered?(:_refresh_cursor_).must_equal(true) }
      it { Vedeu.events.registered?(:_refresh_group_).must_equal(true) }
      it { Vedeu.events.registered?(:_resize_).must_equal(true) }
      it { Vedeu.events.registered?(:_show_group_).must_equal(true) }
    end

    context 'the cursor specific events are defined' do
      it { Vedeu.events.registered?(:_cursor_hide_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_show_).must_equal(true) }
      it { Vedeu.events.registered?(:_hide_cursor_).must_equal(true) }
      it { Vedeu.events.registered?(:_show_cursor_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_down_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_left_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_right_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_up_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_origin_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_position_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_reposition_).must_equal(true) }
      it { Vedeu.events.registered?(:_cursor_reset_).must_equal(true) }
    end

    context 'the geometry specific events are defined' do
      it { Vedeu.events.registered?(:_geometry_down_).must_equal(true) }
      it { Vedeu.events.registered?(:_geometry_left_).must_equal(true) }
      it { Vedeu.events.registered?(:_geometry_right_).must_equal(true) }
      it { Vedeu.events.registered?(:_geometry_up_).must_equal(true) }
      it { Vedeu.events.registered?(:_maximise_).must_equal(true) }
      it { Vedeu.events.registered?(:_unmaximise_).must_equal(true) }
    end

    context 'the drb specific events are defined' do
      it { Vedeu.events.registered?(:_drb_input_).must_equal(true) }
      it { Vedeu.events.registered?(:_drb_retrieve_output_).must_equal(true) }
      it { Vedeu.events.registered?(:_drb_store_output_).must_equal(true) }
      it { Vedeu.events.registered?(:_drb_restart_).must_equal(true) }
      it { Vedeu.events.registered?(:_drb_start_).must_equal(true) }
      it { Vedeu.events.registered?(:_drb_status_).must_equal(true) }
      it { Vedeu.events.registered?(:_drb_stop_).must_equal(true) }
    end

    context 'the focus specific events are defined' do
      it { Vedeu.events.registered?(:_focus_by_name_).must_equal(true) }
      it { Vedeu.events.registered?(:_focus_next_).must_equal(true) }
      it { Vedeu.events.registered?(:_focus_prev_).must_equal(true) }
    end

    context 'the menu specific events are defined' do
      it { Vedeu.events.registered?(:_menu_bottom_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_current_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_deselect_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_items_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_next_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_prev_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_selected_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_select_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_top_).must_equal(true) }
      it { Vedeu.events.registered?(:_menu_view_).must_equal(true) }
    end

    context 'the refresh event for all registered interfaces is defined' do
      it { Vedeu.events.registered?(:_refresh_).must_equal(true) }
    end

    it { Vedeu.events.registered?(:_hide_interface_).must_equal(true) }
    it { Vedeu.events.registered?(:_show_interface_).must_equal(true) }
    it { Vedeu.events.registered?(:_toggle_interface_).must_equal(true) }

  end # Bindings

end # Vedeu
