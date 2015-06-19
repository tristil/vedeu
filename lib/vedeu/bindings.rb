module Vedeu

  # Creates system events which when called provide a variety of core functions
  # and behaviours. They are soft-namespaced using underscores.
  #
  # @note
  #   Unbinding any of these events is likely to cause problems, so I would
  #   advise leaving them alone. A safe rule: if the name starts with an
  #   underscore, it's probably used by Vedeu internally.
  #
  # :nocov:
  #
  module Bindings

    Vedeu.bind(:_drb_input_) do |data, type|
      Vedeu.log(type: :drb, message: "Sending input (#{type})")

      case type
      when :command then Vedeu.trigger(:_command_, data)
      else Vedeu.trigger(:_keypress_, data)
      end
    end

    Vedeu.bind(:_drb_retrieve_output_) { Vedeu::VirtualBuffer.retrieve }

    Vedeu.bind(:_drb_store_output_) do |data|
      Vedeu::VirtualBuffer.store(Vedeu::Terminal.virtual.output(data))
    end

    Vedeu.bind(:_drb_restart_) { Vedeu::Distributed::Server.restart }
    Vedeu.bind(:_drb_start_)   { Vedeu::Distributed::Server.start }
    Vedeu.bind(:_drb_status_)  { Vedeu::Distributed::Server.status }
    Vedeu.bind(:_drb_stop_)    { Vedeu::Distributed::Server.stop }

    # Vedeu triggers this event when `:_exit_` is triggered. You can hook into
    # this to perform a special action before the application terminates. Saving
    # the user's work, session or preferences might be popular here.
    Vedeu.bind(:_cleanup_) do
      Vedeu.trigger(:_drb_stop_)
      Vedeu.trigger(:cleanup)
    end

    # When triggered, Vedeu will trigger a `:cleanup` event which you can define
    # (to save files, etc) and attempt to exit.
    Vedeu.bind(:_exit_) { Vedeu::Application.stop }

    # Vedeu triggers this event when it is ready to enter the main loop. Client
    # applications can listen for this event and perform some action(s), like
    # render the first screen, interface or make a sound. When Vedeu triggers
    # this event, the :_refresh_ event is also triggered automatically.
    Vedeu.bind(:_initialize_) { Vedeu.trigger(:_refresh_) }

    # Will cause the triggering of the `:key` event; which
    # you should define to 'do things'. If the `escape` key is pressed, then
    # `key` is triggered with the argument `:escape`, also an internal event
    # `_mode_switch_` is triggered.
    Vedeu.bind(:_keypress_) { |key| Vedeu.keypress(key) }

    # Will cause the triggering of the `:command` event; which you should define
    # to 'do things'.
    Vedeu.bind(:_command_) { |command| Vedeu.trigger(:command, command) }

    # When triggered with a message will cause Vedeu to log the message if
    # logging is enabled in the configuration.
    Vedeu.bind(:_log_) { |msg| Vedeu.log(type: :debug, message: msg) }

    # When triggered (after the user presses `escape`), Vedeu switches from a
    # "raw mode" terminal to a "cooked mode" terminal. The idea here being that
    # the raw mode is for single keypress actions, whilst cooked mode allows the
    # user to enter more elaborate commands- such as commands with arguments.
    Vedeu.bind(:_mode_switch_) { fail ModeSwitch }

    # When triggered will cause Vedeu to trigger the `:_clear_` and `:_refresh_`
    # events. Please see those events for their behaviour.
    Vedeu.bind(:_resize_, delay: 0.15) { Vedeu.resize }

    Vedeu.bind(:tick) { |t| Vedeu.log(type: :debug, message: "Tick: #{t}") }
    Vedeu.bind(:tock) { |t| Vedeu.log(type: :debug, message: "Tock: #{t}") }

    # Hide the cursor of the named interface or interface currently in focus.
    Vedeu.bind(:_cursor_hide_) do |name|
      Vedeu::Visibility.for_cursor(name).hide
    end

    # Show the cursor of the named interface or interface currently in focus.
    Vedeu.bind(:_cursor_show_) do |name|
      Vedeu::Visibility.for_cursor(name).show
    end

    # @see {Vedeu::Move}
    %w(cursor view).each do |model|
      [:down, :left, :right, :up].each do |direction|
        Vedeu.bind("_#{model}_#{direction}_".to_sym) do |name|
          klass = {
            'cursor' => Vedeu::Cursor,
            'view'   => Vedeu::Geometry,
          }.fetch(model)

          Vedeu::Move.by_name(klass, direction, name)
        end
      end
    end

    # @see {Vedeu::Move}
    Vedeu.bind(:_cursor_origin_) do |name|
      Vedeu::Move.by_name(Vedeu::Cursor, :origin, name)
    end

    # When triggered will return the current position of the cursor.
    Vedeu.bind(:_cursor_position_) do |name|
      named  = name ? name : Vedeu.focus
      cursor = Vedeu.cursors.by_name(named)

      Vedeu.log(type: :debug, message: cursor.inspect)

      Vedeu::Position.new(cursor.y, cursor.x) if cursor
    end

    # @see {Vedeu::Move}
    Vedeu.bind(:_cursor_reset_) { |name| Vedeu.trigger(:_cursor_origin_, name) }

    # When triggered with an interface name will focus that interface and
    # restore the cursor position and visibility.
    Vedeu.bind(:_focus_by_name_) { |name| Vedeu.focus_by_name(name) }

    # When triggered will focus the next interface and restore the cursor
    # position and visibility.
    Vedeu.bind(:_focus_next_) { Vedeu.focus_next }

    # When triggered will focus the previous interface and restore the cursor
    # position and visibility.
    Vedeu.bind(:_focus_prev_) { Vedeu.focus_previous }

    # Requires target menu name as argument. Makes the last menu item the
    # current menu item.
    Vedeu.bind(:_menu_bottom_) { |name| Vedeu.menus.find(name).bottom_item }

    # Requires target menu name as argument. Returns the current menu item.
    Vedeu.bind(:_menu_current_) { |name| Vedeu.menus.find(name).current_item }

    # Requires target menu name as argument. Deselects all menu items.
    Vedeu.bind(:_menu_deselect_) { |name| Vedeu.menus.find(name).deselect_item }

    # Requires target menu name as argument. Returns all the menu items with
    # respective `current` or `selected` boolean indicators.
    Vedeu.bind(:_menu_items_) { |name| Vedeu.menus.find(name).items }

    # Requires target menu name as argument. Makes the next menu item the
    # current menu item, until it reaches the last item.
    Vedeu.bind(:_menu_next_) { |name| Vedeu.menus.find(name).next_item }

    # Requires target menu name as argument. Makes the previous menu item the
    # current menu item, until it reaches the first item.
    Vedeu.bind(:_menu_prev_) { |name| Vedeu.menus.find(name).prev_item }

    # Requires target menu name as argument. Returns the selected menu item.
    Vedeu.bind(:_menu_selected_) { |name| Vedeu.menus.find(name).selected_item }

    # Requires target menu name as argument. Makes the current menu item also
    # the selected menu item.
    Vedeu.bind(:_menu_select_) { |name| Vedeu.menus.find(name).select_item }

    # Requires target menu name as argument. Makes the first menu item the
    # current menu item.
    Vedeu.bind(:_menu_top_) { |name| Vedeu.menus.find(name).top_item }

    Vedeu.bind(:_menu_traverse_) { |name| Vedeu.menus.find(name).traverse      }

    # Requires target menu name as argument. Returns a subset of the menu items;
    # starting at the current item to the last item.
    Vedeu.bind(:_menu_view_) { |name| Vedeu.menus.find(name).view }

    # Clears the whole terminal space, or the named interface area to be cleared
    # if given.
    Vedeu.bind(:_clear_) { |name| Vedeu::Clear.by_name(name) }

    # Clears the spaces occupied by the interfaces belonging to the named group.
    Vedeu.bind(:_clear_group_) { |name| Vedeu::Clear.by_group(name) }

    # Will cause all interfaces to refresh, or the named interface if given.
    #
    # @note
    #   Hidden interfaces will be still refreshed in memory but not shown.
    Vedeu.bind(:_refresh_) do |name|
      name ? Vedeu::Refresh.by_name(name) : Vedeu::Refresh.all
    end

    # Will cause the named cursor to refresh, or the cursor of the interface
    # which is currently in focus.
    Vedeu.bind(:_refresh_cursor_) { |name| Vedeu::RefreshCursor.render(name) }

    # Will cause all interfaces in the named group to refresh.
    Vedeu.bind(:_refresh_group_) { |name| Vedeu::Refresh.by_group(name) }

    # Will clear the terminal and then show all of the interfaces belonging to
    # the named group.
    Vedeu.bind(:_show_group_) do |name|
      Vedeu.trigger(:_clear_)
      Vedeu.trigger(:_refresh_group_, name)
    end

    # Will hide all of the interfaces belonging to the named group. Useful for
    # hiding part of that which is currently displaying in the terminal.
    #
    # @note
    #   This may be rarely used, since the action of showing a group using
    #   `Vedeu.trigger(:_show_group_, group_name)` will effectively clear the
    #   terminal and show the new group.
    Vedeu.bind(:_hide_group_) { |name| Vedeu.trigger(:_clear_group_, name) }

    # Will hide the named interface. If the interface is currently visible, it
    # will be cleared- rendered blank. To show the interface, the
    # ':_show_interface_' event should be triggered.
    # Triggering the ':_hide_group_' event to which this named interface belongs
    # will also hide the interface.
    Vedeu.bind(:_hide_interface_) { |name| Vedeu.buffers.by_name(name).hide }

    # Will show the named interface. If the interface is currently invisible, it
    # will be shown- rendered with its latest content. To hide the interface,
    # the ':_hide_interface_' event should be triggered.
    # Triggering the ':_show_group_' event to which this named interface belongs
    # will also show the interface.
    Vedeu.bind(:_show_interface_) { |name| Vedeu.buffers.by_name(name).show }

    # Will toggle the visibility of the named interface. If the interface is
    # currently visible, the area it occupies will be clears and the interface
    # will be marked invisible. If the interface is invisible, then the
    # interface will be marked visible and rendered in the area it occupies.
    #
    # @note
    #   If an interface is marked visible whilst another view is occupying some
    #   or all of the interface's current position, the interface will overwrite
    #   this area- this may cause visual corruption.
    Vedeu.bind(:_toggle_interface_) do |name|
      if Vedeu.interfaces.by_name(name).visible?
        Vedeu.trigger(:_hide_interface_, name)

      else
        Vedeu.trigger(:_show_interface_, name)

      end
    end

    # Will maximise the named interface geometry. This means it will occupy all
    # of the available space on the terminal window.
    Vedeu.bind(:_maximise_) { |name| Vedeu.geometries.by_name(name).maximise }

    # Will unmaximise the named interface geometry. Previously, if a geometry
    # was maximised, then triggering the unmaximise event will return it to its
    # usual defined size (terminal size permitting: if the terminal has been
    # resized, then the new geometry size should adapt).
    Vedeu.bind(:_unmaximise_) do |name|
      Vedeu.geometries.by_name(name).unmaximise
    end

  end # Bindings
  # :nocov:

end # Vedeu
