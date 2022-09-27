echo "checking requirements"

wget -q https://raw.githubusercontent.com/uw-midsun/box/requirements/requirements.sh -O requirements.sh

if cmp --silent -- "requirements.sh" "completed_requirements.sh"; then
  echo "setup up to date"
  exit
fi

./requirements.sh

mv "requirements.sh" "completed_requirements.sh"
ls
