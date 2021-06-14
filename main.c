#include <allegro5/allegro5.h>
#include <allegro5/allegro_font.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

void drawball(char size, char* string);

int main() 
{
    char* string = "duuuża kupa kurde\n";
    drawball(strlen(string), string);

    al_init();
    al_install_mouse();
    al_install_keyboard();

    ALLEGRO_DISPLAY* disp = al_create_display(800, 600);
    ALLEGRO_EVENT_QUEUE* queue = al_create_event_queue();
    ALLEGRO_FONT* font = al_create_builtin_font();
    ALLEGRO_EVENT event;

    al_register_event_source(queue, al_get_keyboard_event_source());
    al_register_event_source(queue, al_get_display_event_source(disp));

    int i = 0;
    char* i_str = malloc(5);

    while(1)
    {
        // allegro procedures and assembly
        al_clear_to_color(al_map_rgb(255, 255, 255));
        al_draw_text(font, al_map_rgb(0, 0, 0), 0, 0, 0, i_str);
        al_flip_display();
        al_wait_for_event(queue, &event);
        if (event.type == ALLEGRO_KEY_BACK || event.type == ALLEGRO_EVENT_DISPLAY_CLOSE)
        {
            break;
        }
        else
        {
            i++;
            sprintf(i_str, "%d", i);
        }
    }

    free(i_str);
    al_destroy_font(font);
    al_destroy_display(disp);
    al_destroy_event_queue(queue);

    return 0;
}