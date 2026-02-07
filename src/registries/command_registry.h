#pragma once

#include "commands/command.hpp"
#include <vector>
#include <memory>

class CommandRegistry {
public:
    static CommandRegistry & instance();

    void add(std::unique_ptr<ICommand> cmd);
    void register_all(dpp::cluster &bot);
    void handle(const dpp::slashcommand_t &event);

private:
    std::vector<std::unique_ptr<ICommand>> commands;
};
