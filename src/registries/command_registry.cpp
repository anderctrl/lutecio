#include "command_registry.h"

CommandRegistry &CommandRegistry::instance() {
    static CommandRegistry inst;
    return inst;
}

void CommandRegistry::add(std::unique_ptr<ICommand> cmd) {
    commands.push_back(std::move(cmd));
}

void CommandRegistry::register_all(dpp::cluster &bot) {
    for (auto &cmd : commands) {
        cmd->register_command(bot);
    }
}

void CommandRegistry::handle(const dpp::slashcommand_t &event) {
    for (auto &cmd : commands) {
        cmd->handle(event);
    }
}
