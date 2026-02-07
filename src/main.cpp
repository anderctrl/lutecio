#include "commands/ping_command.hpp"
#include "registries/command_registry.h"
#include <cstdio>
#include <cstdlib>
#include <dpp/dpp.h>
#include <memory>

int main()
{
    const char *BOT_TOKEN = std::getenv("DISCORD_TOKEN");
    if (!BOT_TOKEN)
    {
        throw std::runtime_error("DISCORD_TOKEN not set");
    }

    dpp::cluster bot(BOT_TOKEN, dpp::i_default_intents);

    bot.on_log([](const dpp::log_t &log) { std::cout << "[" << log.severity << "] " << log.message << std::endl; });

    CommandRegistry::instance().add(std::make_unique<PingCommand>());

    bot.on_slashcommand([&bot](const dpp::slashcommand_t &event) {
        printf("Command received: %s\n", event.command.get_command_name().c_str());

        CommandRegistry::instance().handle(event);
    });

    bot.on_ready([&bot](const dpp::ready_t &event) {
        if (dpp::run_once<struct register_bot_commands>())
        {
            CommandRegistry::instance().register_all(bot);
        }
    });

    bot.start(dpp::st_wait);
}
