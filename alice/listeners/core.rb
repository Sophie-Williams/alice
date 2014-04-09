require 'cinch'

module Alice

  module Listeners

    class Core

      include Cinch::Plugin

      match /\!cookie (.+)/, method: :cookie, use_prefix: false
      match /\!pants/, method: :pants, use_prefix: false
      match /\!help/, method: :help, use_prefix: false
      match /\<\.\</, method: :shifty_eyes, use_prefix: false
      match /\>\.\>/, method: :shifty_eyes, use_prefix: false
      match /^ha|^bwa|^lol/i, method: :laugh, use_prefix: false
      match /^grr|^arg|^blech|^blegh|^ugh|frown|sigh/i, method: :frown, use_prefix: false
      match /to rule them all/, method: :bind_them, use_prefix: false

      listen_to :nick, method: :update_nick
      listen_to :join, method: :maybe_say_hi

      def bind_them(m)
        m.action_reply("solemnly intones, 'And in the darkness bind() them.'")
      end

      def maybe_say_hi(m)
        return if Alice::Util::Mediator.is_bot?(m.user.nick)
        return unless Alice::Util::Randomizer.one_in_ten
        m.action_reply(Alice::Util::Randomizer.greeting(m.user.nick))
      end

      def laugh(m)
        return unless rand(5) == 1
        m.action_reply(Alice::Util::Randomizer.laughter_with(actor, name))
      end

      def frown(m)
        return unless rand(5) == 1
        name = m.user.nick
        sound = [
          "frowns.",
          "agrees with #{name}.",
          "sides with #{name}.",
          "offers chocolate.",
          "offers alcohol.",
          "shakes her head.",
          "sighs.",
          "lets out a long sigh."
        ].sample
        m.action_reply(sound)
      end

      def shifty_eyes
        return unless [1,2].sample == 1
        m.action_reply "thinks #{who} looks pretty shifty."
      end

      def cookie(m, who)
        return unless Alice::User.find_or_create(who)
        m.action_reply "tempts #{who} with a cookie."
      end

      def pants(m)
        m.action_reply "giggles."
      end

      def help(m)
        m.reply("!bio sets your bio, !fact sets a fact about yoursef.")
        m.reply("Learn more about your fellow hackers by asking who they are or for me to tell you about them.")
        m.reply("I know lots of stuff. Use !facts to prove it.")
        m.reply("Beware the fruitcake.")
      end

      def update_nick(m)
        Alice::User.update_nick(m.user.nick, m.user.last_nick)
      end

      def sender_is_self?(sender, who)
        sender.user.nick == who
      end

    end

  end

end
