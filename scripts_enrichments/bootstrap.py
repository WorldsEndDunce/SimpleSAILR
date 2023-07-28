import numpy as np

def bootstrap(count, total, depth=1000):
    # Simulate the binomial distribution
    bootstraped_counts = np.random.binomial(total * 10000, count / total, size=depth) if total == 1 else np.random.binomial(total, count / total, size=depth)

    # Calculate the 95% confidence interval
    bootstraped_lower = np.percentile(bootstraped_counts, 2.5)
    bootstraped_upper = np.percentile(bootstraped_counts, 97.5)
    bootstraped_std = (bootstraped_upper - bootstraped_lower) / 2

    return [count, bootstraped_std / 10000 if total == 1 else bootstraped_std] # List of sampled count and the margin of error up or down
