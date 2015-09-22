module Features
  module AjaxHelpers
    
    def wait_for_ajax
      counter = 0
      while true

        active = page.execute_script("return $.active").to_i
        break if active < 1
        counter += 1
        sleep(0.1)
        raise "AJAX request took longer than 5 seconds OR there was a JS error. Check your console." if counter >= 50
      end
    end

  end
end