#!/usr/bin/env ruby

lib_dir = File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'vedeu'

# An example application to demonstrate colours, cursor and interface movement,
# maximising/unmaximising of interfaces and toggling of cursors and interfaces.
class VedeuPanelApp

  include Vedeu

  configure do
    debug!
    log '/tmp/vedeu_panel_app.log'
    # renderers Vedeu::Renderers::File
  end

  # line { centre 'Blue',        width: 20, background: '#2196f3' }
  interface 'main_interface' do
    border 'main_interface' do
      colour foreground: '#000000', background: '#cddc39' # lime
      title 'Panel: Yes/No'
    end
    colour foreground: '#000000', background: '#cddc39'
    cursor!
    geometry 'main_interface' do
      centred!
      width  columns(10)
      height 9
    end
  end

  keymap('_global_') do
    key(:up)    { Vedeu.trigger(:_cursor_up_)    }
    key(:right) { Vedeu.trigger(:_cursor_right_) }
    key(:down)  { Vedeu.trigger(:_cursor_down_)  }
    key(:left)  { Vedeu.trigger(:_cursor_left_)  }
  end

  renders do
    view 'main_interface' do
      lines do
        line ' '
        line 'This is an example panel. It should be used for Yes/No questions.'
        line 'Do you like it?'
      end
      button('Yes!', :confirm, true)
    end
  end

  focus_by_name 'main_interface'

  def self.start(argv = ARGV)
    Vedeu::Launcher.execute!(argv)
  end

end

VedeuPanelApp.start(ARGV)