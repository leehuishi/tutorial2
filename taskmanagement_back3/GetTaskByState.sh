#!/bin/bash
NUM_PASSES=0
NUM_CASES=0

STATUS_OK=200
STATUS_INVALID_FIELDS=400
STATUS_INVALID_USER=401
STATUS_INTERNAL_ERR=500

DOMAIN=http://localhost:3502/GetTaskByState
USERNAME="test_user"
PASSWORD="pa55word!"
USERNAME_DOES_NOT_EXIST="wronguser"
WRONG_PASSWORD="@WrongPass"
APP_ACRONYM="test_app"

function test_start() {
    ((NUM_CASES++))
    echo "Starting Test $NUM_CASES: $1"
}

function test_end() {
    if (($OUTPUT_STATUS == $EXPECTED_STATUS))
    then
        ((NUM_PASSES++))
        echo "$NUM_CASES: [PASS] EXPECTED $EXPECTED_STATUS, GOT $OUTPUT_STATUS"
    else
        echo "$NUM_CASES: [FAIL] EXPECTED $EXPECTED_STATUS, GOT $OUTPUT_STATUS"
    fi
}


# Some curl options:
# -s: Don't diplay progress bar.
# -w: Write an output into our variable.

test_start 'Valid input (open)'
EXPECTED_STATUS=$STATUS_OK
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start 'Valid input (todo)'
EXPECTED_STATUS=$STATUS_OK
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"todo\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start 'Valid input (doing)'
EXPECTED_STATUS=$STATUS_OK
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"doing\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start 'Valid input (done)'
EXPECTED_STATUS=$STATUS_OK
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"done\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start 'Valid input (closed)'
EXPECTED_STATUS=$STATUS_OK
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"closed\"
}" -s -w "%{response_code}" --output /dev/null)
test_end


# *************************** Username ***************************

# Test for username that does not exist
test_start "Username does not exist"
EXPECTED_STATUS=$STATUS_INVALID_USER
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME_DOES_NOT_EXIST\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"open\"
}" -s -w "%{http_code}" --output /dev/null)
test_end

test_start "Empty username"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "Username is not a string"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : [\"$USERNAME\"],
    \"password\" : \"$PASSWORD\",
  \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "Missing username"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"password\" : \"$PASSWORD\",
   \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

# *************************** Password ***************************

test_start "Wrong password"
EXPECTED_STATUS=$STATUS_INVALID_USER
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$WRONG_PASSWORD\",
 \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "Empty password"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"""\",
   \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "Password is not a string"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : [\"$PASSWORD\"],
   \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "Missing password"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
 \"Task_state\" : \"open\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

# *************************** Task State ***************************

test_start "Empty state"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"""\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "State is not a string"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : [\"open\"]
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "Missing state"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

test_start "State is not a valid state"
EXPECTED_STATUS=$STATUS_INVALID_FIELDS
OUTPUT_STATUS=$(curl --location $DOMAIN \
--header 'Content-Type: application/json' \
--data "{
    \"username\" : \"$USERNAME\",
    \"password\" : \"$PASSWORD\",
    \"Task_state\" : \"OPEN\"
}" -s -w "%{response_code}" --output /dev/null)
test_end

# *************************** Conclusion ***************************

# Output final result.
echo "Conclusion"
if (($NUM_CASES == $NUM_PASSES))
then
    echo "[SUCCESS] $NUM_PASSES OF $NUM_CASES PASSED"
else
    echo "[FAILURE] $NUM_PASSES OF $NUM_CASES PASSED"
fi