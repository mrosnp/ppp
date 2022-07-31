require "trello"

class MealPrep
  BOARD_ID = ENV["COOKING_BOARD_ID"]

  PLACEHOLDER_LABEL = "placeholder"
  MAIN_LABEL = "main"
  SIDE_LABEL = "side"
  SNACK_LABEL = "snack"
  INDIVIDUAL_ITEM_LABEL = "ind"

  PLACEHOLDERS = "placeholders"
  MAINS = "mains"
  SIDES = "sides"
  SNACKS = "snacks"
  INDIVIDUAL_ITEMS = "individual items"
  UNCATEGORIZED = "uncategorized"

  CURRENT = "current"
  PREVIOUS = "previous"
  GROCERY = "grocery list"

  def initialize
    Trello.configure do |config|
      config.developer_public_key = ENV["TRELLO_DEVELOPER_PUBLIC_KEY"]
      config.member_token = ENV["TRELLO_MEMBER_TOKEN"]
    end
  end

  def print_current_list_to_file
    curr_list = get_list(CURRENT)
    # preprend current list to markdown file
  end

  def arrange_board_for_next_day
    clear_list(PREVIOUS)
    move_curr_to_prev_list
  end

  def move_curr_to_prev_list
    # for cards in current list
    #   set_card_to_list(card, PREVIOUS_LIST)
    # end
  end

  def set_card_to_list(card, list)
  end

  def reset_planning_lists
    [CURRENT, PREVIOUS, GROCERY].each do |list_name| 
      clear_list(list_name)
    end
  end

  private 

  def cooking_board
    @cooking_board ||= Trello::Board.find(BOARD_ID)
  end

  def placeholders_list
    @placeholders_list ||= get_list(PLACEHOLDERS)
  end

  def mains_list
    @mains_list ||= get_list(MAINS)
  end

  def sides_list
    @sides_list ||= get_list(SIDES)
  end

  def snacks_list
    @snacks_list ||= get_list(SNACKS)
  end

  def individual_items_list
    @individual_items_list ||= get_list(INDIVIDUAL_ITEMS)
  end

  def uncategorized_list
    @uncategorized_list ||= get_list(UNCATEGORIZED)
  end

  def clear_list(name)
    list = get_list(name)
    list.cards.each do |card|
      move_card_to_matching_list(card)
    end
  end

  def get_list(name)
    cooking_board.lists.filter{ |list| list.attributes["name"] == name }.first
  end

  def move_card_to_matching_list(card)
    dominant_label = dominant_label(card)

    case dominant_label
    when PLACEHOLDER_LABEL
      card.move_to_list(placeholders_list)
    when MAIN_LABEL
      card.move_to_list(mains_list)
    when SIDE_LABEL
      card.move_to_list(sides_list)
    when SNACK_LABEL
      card.move_to_list(snacks_list)
    when INDIVIDUAL_ITEM_LABEL
      card.move_to_list(individual_items_list)
    else
      card.move_to_list(uncategorized_list)
    end
  end

  def dominant_label(card)
    label_names = card.labels.map{ |label| label.attributes["name"] }
    label_names.include?(PLACEHOLDER_LABEL) ? PLACEHOLDER_LABEL : label_names.first
  end
end
