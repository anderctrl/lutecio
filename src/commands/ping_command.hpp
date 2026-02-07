#pragma once
#include "command.hpp"
#include <dpp/cluster.h>

class PingCommand : public ICommand
{
  public:
    void register_command(dpp::cluster &bot) override;
    void handle(const dpp::slashcommand_t &event) override;

    dpp::cluster *bot;
};

inline void PingCommand::register_command(dpp::cluster &bot)
{
    this->bot = &bot;
    // bot.global_command_create(dpp::slashcommand("ping", "Shows websocket ping", bot.me.id));
    bot.guild_command_create(dpp::slashcommand("ping", "Shows websocket ping", bot.me.id), 954334832228442132);
}

inline void PingCommand::handle(const dpp::slashcommand_t &event)
{
    uint32_t shard = event.from()->shard_id;

    if (auto client = bot->get_shard(shard))
    {
        double ping_seconds = client->websocket_ping;

        uint64_t ping_ms = static_cast<uint64_t>(ping_seconds * 1000.0);

        std::string replystr = "Pong!\n"
                               "Gateway ping: **" +
                               std::to_string(ping_ms) + " ms**";

        event.reply(replystr);
    }
    else
    {
        event.reply("Pong!\nGateway ping: **unknown** (shard not connected)");
    }
}
