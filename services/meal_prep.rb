require "trello"

module Services
  class MealPrep
    BOARD_ID = ENV["COOKING_BOARD_ID"]

    label_list_ids_map = {
      :placeholder => "placeholders",
      :main => "mains",
      :sides -> "sides",
      :snack => "snacks",
      :ind => "individual items"
    }

    UNCATEGORIZED_LIST = "uncategorized"
    CURRENT_LIST = "current"
    PREVIOUS_LIST = "preivous"
    GROCERY_LIST = "grocery list"

    def print_current_list_to_file
      # preprend current list to markdown file
    end

    def arrange_board_for_next_day
      clear_prev_list
      move_curr_to_prev_list
    end

    def move_curr_to_prev_list
      clear_list(PREVIOUS_LIST)
      # for cards in current list
      #   set_card_to_list(card, PREVIOUS_LIST)
      # end
    end

    def set_card_to_list(card, list)
    end

    def clear_list(list)
      # move cards to respective columns
      #
    end

    def reset_planning_lists
      [CURRENT_LIST, PREVIOUS_LIST, GROCERY_LIST].each do |list| 
        clear_list(list)
      end
    end
  end
end