import os
import telebot
import psycopg2
import schedule
import time
import threading
import datetime
from sshtunnel import SSHTunnelForwarder
import html

bot = telebot.TeleBot('6985784657:AAGbKivYJshIBlrnm7uZavTj7SqsejGXhds')

@bot.message_handler(commands=['start', 'hello'])
def send_welcome(message):
    bot.reply_to(message, "Howdy, how are you doing?")

@bot.message_handler(commands=['func'])
def execute_func(message):
    try:
        with SSHTunnelForwarder(
                ('51.89.165.147', 22),
                ssh_username="debian",
                ssh_password="vtNNuGeDxerZ",
                remote_bind_address=('localhost', 5432)
        ) as server:
            server.start()
            print("Server connected")

            params = {
                'database': 'eat_it',
                'user': 'eat_it',
                'password': 'eat_it',
                'host': 'localhost',
                'port': server.local_bind_port
            }

            conn = psycopg2.connect(**params)
            curs = conn.cursor()
            print("Database connected")

            # Execute your SQL query here
            user_input = message.text.lower()
            if 'locales' in user_input:
                query = "SELECT * FROM locales;"
            elif 'users' in user_input:
                query = "SELECT count (*) FROM users;"
            curs.execute(query)

            # Fetch the result
            result = curs.fetchone()
            count_value = result[0]

            # Print the query result to the console
            print("Query result:")
            for row in result:
                print(row)

            # Send a message to the Telegram user with the result
            formatted_message = f"👥 *Total number of users:* {count_value}"
            bot.reply_to(message, formatted_message, parse_mode='MarkdownV2')


    except Exception as e:
        print(f"Connection Failed: {e}")
        bot.reply_to(message, "Connection Failed")

def check_for_new_users():
    try:
        current_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        print(f'{current_time} Scanning for new users...')
        with SSHTunnelForwarder(
                ('51.89.165.147', 22),
                ssh_username="debian",
                ssh_password="vtNNuGeDxerZ",
                remote_bind_address=('localhost', 5432)
        ) as server:
            server.start()
            print("Server connected")

            params = {
                'database': 'eat_it',
                'user': 'eat_it',
                'password': 'eat_it',
                'host': 'localhost',
                'port': server.local_bind_port
            }

            conn = psycopg2.connect(**params)
            curs = conn.cursor()

            # Check for new users
            query = "SELECT username, email  FROM users WHERE date > CURRENT_TIMESTAMP - INTERVAL '1 minute';"
            curs.execute(query)

            # Fetch the result
            new_users = curs.fetchall()

            def escape_markdown(text):
                return html.escape(text)

            # Send alert for new users
            for user in new_users:
                username = user[0]  # Access the first element of the tuple
                email = user[1]  # Access the second element of the tuple
                escaped_username = escape_markdown(username)
                escaped_email = escape_markdown(email)

                message = f"✨ New user has registered:\nusername: {escaped_username}\nemail: {escaped_email}"

                bot.send_message(chat_id='-4143812753', text=message)

    except Exception as e:
        print(f"Connection Failed: {e}")

schedule.every(1).minutes.do(check_for_new_users)

# Define a function to run the bot's polling in a separate thread
def run_bot_polling():
    bot.polling()

# Run the bot's polling in a separate thread
bot_thread = threading.Thread(target=run_bot_polling)
bot_thread.start()

# Run the scheduled tasks in the main thread
while True:
    schedule.run_pending()
    time.sleep(1)
