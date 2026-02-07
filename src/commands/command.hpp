#pragma once
#include <dpp/dpp.h>

class ICommand {
public:
    virtual ~ICommand() = default;

    virtual void register_command(dpp::cluster &bot) = 0;

    virtual void handle(const dpp::slashcommand_t &event) = 0;
};
