echo "Checking requirements"

# first time this script is ran, vm might not have anything
# [[ -f "completed_requirements.sh" ]] || apt update; apt install apt-get curl

# rm "requirements.sh" "completed_requirements.sh"

curl -s https://raw.githubusercontent.com/uw-midsun/box/requirements/requirements.sh -O "requirements.sh"

if [ ! -f "requirements.sh" ]; then
  echo "Cannot download newest requirements"
  exit
fi

if cmp --silent -- "requirements.sh" "completed_requirements.sh"; then
  echo "Requirements up to date"
  exit
fi

echo "Installing new requirements..."

chmod +x requirements.sh
./requirements.sh

mv "requirements.sh" "completed_requirements.sh"
