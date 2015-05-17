# Net-Symon-Netbrite
Perl library for controlling Symon Netbrite II LED signs via XMPP.

## Why XMPP?
At SkullSpace, we like to take our flashing lights on the road with us when we do events.
XMPP lets us talk to the sign server wherever it might be, without having to worry about
port forwarding rules. Built in persistence handling and message queuing came as added bonuses.

## Setup
Install required dependencies (todo: Build list of dependencies) and configure app.ini with the
address of your NetBrite sign. You will also need to enter the credentials for the Jabber account
you wish to use for the sign.

## Talking to the sign
Simply use your favourite jabber client to send a message to the sign's jabber account! The sign will
give your message 10 seconds to display before yielding to the next person's message.

### Formatting Text
- {scrollon} - Enables scrolling for the message
- (scrolloff} - The following message will not scroll
- {red}{green}{yellow} - The following text will be coloured according to these tags.
- {blinkon} - The message will blink annoyingly
- {blinkoff} - The message will stop blinking
- {left}{center}{right} - Set the text alignment
- {font _fontname_} - Change the font

### Fonts
- monospace_7
- monospace_16
- monospace_24
- proportional_7
- proportional_5
- proportional_9
- proportional_11
- bold_proportional_7
- bold_proportional_11
- script_16
- picture_24

## Thanks
Special thanks to https://github.com/bwilber for converting much of the sign's interface to Perl. The initial
reverse engineering effort was started by the good person at http://www.thepenguinmaster.com/. Direct any donations
their way.
