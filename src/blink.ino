extern "C" int main(void)
{
    pinMode(LED_BUILTIN, OUTPUT);     
    digitalWrite(LED_BUILTIN, HIGH);

	while (1) {
		digitalWriteFast(LED_BUILTIN, HIGH);
		delay(250);
		digitalWriteFast(LED_BUILTIN, LOW);
		delay(2000);
	}
}
