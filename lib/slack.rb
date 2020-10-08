#!/usr/bin/env ruby
require 'dotenv'
require "table_print"
require_relative 'workspace'


def main
  Dotenv.load

  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new
  workspace.load_users
  workspace.load_channels
  puts "Amount of users in workspace: #{workspace.users.length}"
  puts "Amount of channels in workspace: #{workspace.channels.length}"


  puts "1. list users\n2. list channels\n3. select user\n4. select channel\n5. quit"
  selection = number_validation(gets.chomp, 5)

  while (1..4).include? selection
    case selection
    when 1
      tp workspace.users, "slack_id", "name", "real_name", "status_text", "status_emoji"
    when 2
      tp workspace.channels, "slack_id", "name", "topic", "member_count"
    when 3, 4
      puts "Please input a name or slack id"
      if selection == 3
        selected_recipient = workspace.select_user(gets.chomp)
      else
        selected_recipient = workspace.select_channel(gets.chomp)
      end

      if selected_recipient
        puts "Would you like details? (yes/no)"
        details_selection = input_validation(gets.chomp.downcase)
        if details_selection == "yes"
          puts workspace.show_details(selected_recipient)
        end
          puts "Would you like to #{selected_recipient.class == User ? "send a message" : "post"} to #{selected_recipient.name}? (yes/no)"
        message_selection = input_validation(gets.chomp.downcase)
        if message_selection == "yes"
          puts "Please write your message."
          message = gets.chomp
          selected_recipient.send_message(message)
        end
      else
        puts "No #{(selection == 3) ? "user" : "channel"} found."
      end

    end

    puts "Make another selection:"
    puts "1. list users\n2. list channels\n3. select user\n4. select channel\n5. quit"
    selection = number_validation(gets.chomp, 5)
  end

  puts "Thank you for using the Ada Slack CLI"
end

def number_validation(input, max_num)
  input = translate_input(input)

  until (1..max_num).include? input
    puts "Invalid input. Please re-enter a selection."
    input = translate_input(gets.chomp)
  end

  return input
end

def input_validation(input)
  until ["yes", "no"].include? input
    puts "Invalid input. Please re-enter either a yes or no."
    input = gets.chomp.downcase
  end
  return input
end

def translate_input(string_input)
  case string_input.downcase
  when "list users", "1"
    return 1
  when "list channels", "2"
    return 2
  when "select user", "3"
    return 3
  when "select channel", "4"
    return 4
  when "quit", "5"
    return 5
  else
    return string_input
  end
end

main if __FILE__ == $PROGRAM_NAME