#!/usr/bin/env ruby

lib_dir = File.dirname(__FILE__) + '/../../lib'
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'vedeu'

# A simple example application to test the input of commands. This will test
# the functionality of 'cooked' mode.
class VedeuTypedCommands

  include Vedeu

  configure do
    debug!
    log '/tmp/vedeu_typed_commands_app.log'
  end

  bind(:_initialize_) { Vedeu.trigger(:_refresh_) }

  interface 'output' do
    colour foreground: '#ff0000', background: '#000022'
    cursor!
  end

  interface 'status' do
    colour foreground: '#00ff00', background: '#003300'
    cursor!
  end

  interface 'command' do
    colour foreground: '#ffff00', background: '#111111'
    cursor!
  end

  keymap('_global_') do
    key(:up,    'k') { Vedeu.trigger(:_cursor_up_)    }
    key(:right, 'l') { Vedeu.trigger(:_cursor_right_) }
    key(:down,  'j') { Vedeu.trigger(:_cursor_down_)  }
    key(:left,  'h') { Vedeu.trigger(:_cursor_left_)  }

    key('q')        { Vedeu.trigger(:_exit_) }
    key(:escape)    { Vedeu.trigger(:_mode_switch_) }
    key(:shift_tab) { Vedeu.trigger(:_focus_prev_) }
    key(:tab)       { Vedeu.trigger(:_focus_next_) }
  end

  border('output') do
    colour foreground: '#aadd00', background: '#000022'
    hide_bottom!
  end
  border('status') do
    colour foreground: '#aadd00', background: '#003300'
    hide_top!
    hide_bottom!
  end
  border('command') do
    colour foreground: '#aadd00', background: '#111111'
    hide_top!
  end

  geometry 'output' do
    centred!
    height 7
    width  40
  end

  geometry('status') do
    height 1
    width  40
    x      use('output').left
    y      use('output').south(0)
  end

  geometry 'command' do
    height 3
    width  40
    x      use('status').left
    y      use('status').south(0)
  end

  focus_by_name 'command'

  renders do
    template_for('output', (File.dirname(__FILE__) + '/output.erb'), nil)
    template_for('status', (File.dirname(__FILE__) + '/status.erb'), nil)
    template_for('command', (File.dirname(__FILE__) + '/command.erb'), nil)
  end

  def self.start(argv = ARGV)
    Vedeu::Launcher.execute!(argv)
  end

end

VedeuTypedCommands.start(ARGV)
