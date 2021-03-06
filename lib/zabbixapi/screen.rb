module Zabbix

  class ZabbixApi
    def get_screen_id(screen_name)

      message = {
        'method' => 'screen.get',
        'params' => {
          'filter' => {
            'name' => screen_name
          }
        }
      }

      response = send_request(message)

      unless response.empty? then
        result = response[0]['screenid']
      else
        result = nil
      end
    end

    def get_screen_parameter(screen_name, param_name)

      message = {
        'method' => 'screen.get',
        'params' => {
          'extendoutput' => '1',
          'filter' => {
            'name' => screen_name
          }
        }
      }

      response = send_request(message)

      unless response.empty? then
        result = response[0][param_name]
      else
        result nil
      end
    end

    def get_screen_graph_ids(screen_id)

      message = {
        'method' => 'screen.get',
        'params' => {
          'extendoutput' => '1',
          'select_screenitems' => '1',
          'screenids' => [ screen_id ]
        }
      }

      response = send_request(message)

      unless ( response.empty?) then
        result = []
        screenitems = response[0]['screenitems']
        screenitems.each() do |item|
          if ( item['resourcetype'].to_i == 0 ) then
            result << item['resourceid']
          end
        end
      else
        result = nil
      end

      return result
    end

    def set_screen_parameter(screen_id, param_name, param_value)

      message = {
        'method' => 'screen.update',
        'params' => {
          param_name => param_value,
          'screenid' => screen_id
        }
      }

      response = send_request(message)

      if not ( response.empty? ) then
        result = true
      else
        result = false
      end

      return result
    end

    def del_all_graphs_from_screen(screen_id)

      message = {
        'method' => 'screen.deleteItems',
        'params' => {
          'screenids' => [ screen_id ],
        }
      }

      response = send_request(message)

      if ( response ) then
        return response
      else
        return nil
      end
    end

    def add_graph_to_screen(screen_id, graph_id, x, y)

      message = {
        'method' => 'screen.addItems',
        'params' => {
          'screenids' => [ screen_id ],
          'screenitems' => [
            {
               'resourcetype' => 'graph',
               'resourceid' => graph_id,
               'width' => '800',
               'height' => '200',
               'x' => x,
               'y' => y,
               'valign' => 'Middle',
               'halign' => 'Centre',
               'colspan' => '0',
               'rowspan' => '0',
               'elements' => '0',
               'dynamic' => '0',
               'url' => '0',
               'style' => '0'
            }
          ]
        }
      }

      response = send_request(message)

      return response
    end

    def add_screen(screen_name, hsize, vsize)

      message = {
        'method' => 'screen.create',
        'params' => {
          'name' => screen_name,
          'hsize' => hsize,
          'vsize' => vsize
        }
      }

      response = send_request(message)

      unless response.empty? then
        result = response['screenids'][0]
      else
        result = nil
      end

      return result
    end
  end
end
