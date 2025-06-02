<?php

declare(strict_types=1);

namespace App\Traits;

use Akbsit\HelperJson\JsonHelper;
use Psr\Log\LoggerInterface;
use Symfony\Contracts\Service\Attribute\Required;
use Throwable;

trait AppLoggerTrait
{
    private readonly LoggerInterface $appLogger;
    private readonly bool $logAppEnable;

    #[Required]
    public function setAppLogger(LoggerInterface $appLogger): void
    {
        $this->appLogger = $appLogger;
    }

    #[Required]
    public function setLogAppEnable(bool $logAppEnable): void
    {
        $this->logAppEnable = $logAppEnable;
    }

    private function log(Throwable|string $message, array $context = null, bool $isError = false): void
    {
        if (!$this->logAppEnable) {
            return;
        }

        if ($message instanceof Throwable) {
            $data = [
                'message' => $message->getMessage(),
                'trace'   => $message->getTraceAsString(),
            ];
        } else {
            $data = [
                'message' => $message,
            ];
        }

        if ($context !== null) {
            $data['context'] = $context;
        }

        $message = JsonHelper::make()->data($data)->encode();

        if ($isError) {
            $this->appLogger->error($message);
        } else {
            $this->appLogger->debug($message);
        }
    }
}
