#!/usr/bin/env bash

MODEL_NAME=$1
PROMPT=$2
curl -X POST "http://localhost:8000/v1/chat/completions" \
	-H "Content-Type: application/json" \
	--data "{
		\"model\": \"${MODEL_NAME}\",
		\"messages\": [
			{
				\"role\": \"user\",
				\"content\": \"${PROMPT}\"
			}
		]
	}"
