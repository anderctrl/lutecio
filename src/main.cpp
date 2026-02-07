#include <cstdlib>
#include <dpp/dpp.h>

int main()
{
    const char *BOT_TOKEN = std::getenv("DISCORD_TOKEN");
    if (!BOT_TOKEN)
    {
        throw std::runtime_error("DISCORD_TOKEN not set");
    }

    dpp::cluster bot(BOT_TOKEN);

    bot.on_log(dpp::utility::cout_logger());

    bot.on_slashcommand([&bot](const dpp::slashcommand_t &event) {
        if (event.command.get_command_name() == "ping")
        {
            uint32_t shard = event.from()->shard_id;
            uint64_t ping = bot.get_shard(shard)->websocket_ping;

            std::string replystr = "Pong!\n"
                                   "Gateway ping: **" +
                                   std::to_string(ping) + " ms**";

            event.reply(replystr);
        }
    });

    bot.on_ready([&bot](const dpp::ready_t &event) {
        if (dpp::run_once<struct register_bot_commands>())
        {
            // bot.global_command_create(dpp::slashcommand("ping", "Ping pong!", bot.me.id));
            bot.guild_command_create(dpp::slashcommand("ping", "Ping pong!", bot.me.id), 954334832228442132);
        }
    });

    bot.start(dpp::st_wait);
}
