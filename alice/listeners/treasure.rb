require 'cinch'

module Alice

  module Listeners

    class Treasure

      include Cinch::Plugin

      match /^\!(.+) (.+)/, method: :treasure, use_prefix: false
      match /^\!forge (.+)/, method: :forge, use_prefix: false
      match /^\!steal (.+)/, method: :steal, use_prefix: false
      match /^\!inventory/, method: :inventory, use_prefix: false

      def inventory(m)
        if user = User.find_or_create(m.user.nick)
          m.reply(user.inventory)
        end
      end

      def forge(m, what)
        unless m.channel.ops.map(&:nick).include?(m.user.nick)
          m.reply("You're not the boss of me, #{m.user.nick}.")
          return
        end
        if treasure = Alice::Treasure.where(name: what.downcase).last
          m.reply("Everyone knows that that's a singleton.")
          return
        end
        user = Alice::User.find_or_create(m.user.nick)
        Alice::Treasure.create(name: what.downcase, user: user)
        m.action_reply("forges a #{what} in the fires of Mount Doom.")
      end

      def steal(m, what)
        return if what == 'forge'
        thief = Alice::User.find_or_create(m.user.nick)
        message = thief.try_stealing(what)
        m.action_reply(message)
      end

      def treasure(m, what, who)
        return if what == 'forge'
        return unless treasure = Alice::Treasure.where(name: what.downcase).last
        message = treasure.transfer_from(m.user.nick).to(who).message
        m.reply(message)
      end

    end

  end

end