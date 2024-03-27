import torch
from flask import Flask, jsonify, request

app = Flask(__name__)


def perform_gpu_operation(input_value):
    """Perform a simple square operation on the GPU and return the result."""
    if torch.cuda.is_available():
        device = torch.device("cuda:0")
    else:
        device = torch.device("cpu")

    # Create a tensor from the input value, move it to the chosen device, and perform the operation
    x = torch.tensor([input_value], dtype=torch.float32).to(device)
    y = x * x

    # Move the tensor back to CPU if necessary and return the numpy array
    if y.is_cuda:
        y = y.to("cpu")
    return y.numpy()[0]


@app.route("/", methods=["GET"])
def square():
    result = perform_gpu_operation(16)
    return f"Result from the GPU: {result}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
