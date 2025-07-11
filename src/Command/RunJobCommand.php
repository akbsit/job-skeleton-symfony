<?php

declare(strict_types=1);

namespace App\Command;

use App\Traits\AppLoggerTrait;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(name: 'app:run:job')]
final class RunJobCommand extends Command
{
    use AppLoggerTrait;

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $io->text("Command {$this->getName()} execute");
        $this->log(__METHOD__);

        return Command::SUCCESS;
    }
}
