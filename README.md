# weighted-choice
## Usage
```bash
cat <<EOF | ./weighted-choice
5
2
2
1
EOF
# Returns a number between 0 and 3 with the specified weights
```
# Proof of randomness
```bash
for _ in {1..1000}; do echo -e "5\n2\n2\n1" | ./weighted-choice; done | sort | uniq -c
# Example output:
# 512 0
# 188 1
# 198 2
# 102 3
```
