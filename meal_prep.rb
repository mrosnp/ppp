require "trello"

class MealPrep
  def initialize
    Trello.configure do |config|
      config.developer_public_key = ENV["TRELLO_DEVELOPER_PUBLIC_KEY"]
      config.member_token = ENV["TRELLO_MEMBER_TOKEN"]
    end
  end

  def print_current_list_to_file
    # preprend current list to markdown file
  end

  def arrange_board_for_next_day
    reset_cards(previous_list)
    current_list.move_all_cards(previous_list)
  end

  def reset_planning_lists
    planning_lists.each do |list| 
      reset_cards(list)
    end
  end

  private 

  def planning_lists
    [current_list, previous_list, grocery_list]
  end

  def label_to_list_mapping
    {
      :placeholder => placeholders_list,
      :main => mains_list,
      :side => sides_list,
      :snack => snacks_list,
      :ind => individual_items_list,
      :uncategorized => uncategorized_list
    }
  end

  def cooking_board
    @cooking_board ||= Trello::Board.find(ENV["COOKING_BOARD_ID"])
  end

  def current_list
    @current_list ||= get_list("current")
  end

  def previous_list
    @previous_list ||= get_list("previous")
  end

  def grocery_list
    @grocery_list ||= get_list("grocery list")
  end

  def placeholders_list
    @placeholders_list ||= get_list("placeholders")
  end

  def mains_list
    @mains_list ||= get_list("mains")
  end

  def sides_list
    @sides_list ||= get_list("sides")
  end

  def snacks_list
    @snacks_list ||= get_list("snacks")
  end

  def individual_items_list
    @individual_items_list ||= get_list("individual items")
  end

  def uncategorized_list
    @uncategorized_list ||= get_list("uncategorized")
  end

  def reset_cards(list)
    list.cards.each do |card|
      move_card_to_matching_list(card)
    end
  end

  def get_list(name)
    cooking_board.lists.filter{ |list| list.name.downcase == name.downcase }.first
  end

  def move_card_to_matching_list(card)
    card_type_label = extract_card_type_label(card)
    matching_list = label_to_list_mapping[card_type_label.to_sym]
    card.move_to_list(matching_list)
  end
  
  def extract_card_type_label(card)
    card.labels.none? ? "uncategorized" : card.labels.first.name
  end
end