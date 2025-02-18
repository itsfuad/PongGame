# Pong Game

A simple implementation of the classic Pong game built using the [LOVE2D](https://love2d.org/) framework.

## Description

This project is a basic implementation of Pong featuring:
- Two paddles controlled by the W/S and Up/Down arrow keys.
- A ball with dynamic speed and angle changes upon paddle collision.
- Scoring, state management (start, playing, paused, game over), and game restart mechanics.

## How to Play

- **Start Game:** Press **space** from the start screen.
- **Move Left Paddle:** Use **W** (up) and **S** (down).
- **Move Right Paddle:** Use **Up** and **Down** arrow keys.
- **Pause Game:** Press **p** to pause/resume.
- **Restart:** After a score or game over, press **space** or **backspace** to reset.

## Game Rules

- Each player scores when the opponent misses the ball.
- The game ends when one player reaches the winning score (default: 5 points).
- In case of a tie during game over, follow the on-screen instructions to restart.

## Requirements

- [LOVE2D](https://love2d.org/) framework installed on your system.

## Running the Game

1. **Using the LOVE2D framework:**  
    Run the following command in your terminal from the project directory:
    ```
    love .
    ```
2. **Compiled Version:**  
    You can also compile the project into a `.love` file as specified in the `.gitignore`.

## Author

Developed by [itsfuad](https://github.com/itsfuad).

Enjoy playing the game and feel free to contribute or raise issues!