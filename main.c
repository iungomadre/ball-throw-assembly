#include <allegro5/allegro5.h>
#include <allegro5/allegro_font.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>


#define WIDTH   800
#define HEIGHT  600
#define V_STEP  100
#define V_START 1700


void drawball(void* pixel_buffer, int width, int height, int x, int y, float V);
// draws throw graph on pixel_buffer passed based on initial velocity


int main() 
{
    bool done = false;
    float V = V_START;
    char* V_stringed = malloc(5);

    // initialise Allegro components
    al_init();
    al_install_mouse();
    al_install_keyboard();

    ALLEGRO_EVENT_QUEUE* queue = al_create_event_queue();
    ALLEGRO_EVENT event;
    ALLEGRO_MOUSE_STATE mouse_state;
    ALLEGRO_DISPLAY* disp = al_create_display(WIDTH, HEIGHT);
    ALLEGRO_BITMAP* bmp = al_create_bitmap(WIDTH, HEIGHT);
    ALLEGRO_LOCKED_REGION* region;
    ALLEGRO_FONT* font = al_create_builtin_font();

    // initialise event sources
    al_register_event_source(queue, al_get_display_event_source(disp));
    al_register_event_source(queue, al_get_mouse_event_source());
    al_register_event_source(queue, al_get_keyboard_event_source());

    // clear initial view 

    al_draw_text(font, al_map_rgb(255, 255, 255), (WIDTH/2-50), HEIGHT/2, 0, "Click to start");
    al_flip_display();

    // main loop
    while(!done)
    {   
        al_wait_for_event(queue, &event);

        switch (event.type)
        {
        case ALLEGRO_EVENT_KEY_DOWN:
            if(event.keyboard.keycode == ALLEGRO_KEY_UP)
            {
                V += V_STEP;
            }
            else if(event.keyboard.keycode == ALLEGRO_KEY_DOWN)
            {
                if (V >= V_STEP ) { V -= V_STEP; }
            }
            // no break here in order to refresh screen from next case

        case ALLEGRO_EVENT_MOUSE_BUTTON_DOWN:

            // get mouse state
            al_get_mouse_state(&mouse_state);

            // clear bitmap
            al_set_target_bitmap(bmp);
            al_clear_to_color(al_map_rgb(255, 255, 255));

            // clear display
            al_set_target_backbuffer(disp);
            al_clear_to_color(al_map_rgb(255, 255, 255));

            // lock and modify bitmap
            region = al_lock_bitmap(bmp, ALLEGRO_PIXEL_FORMAT_RGBA_8888, ALLEGRO_LOCK_READWRITE);
            drawball(region->data, WIDTH*4, HEIGHT, mouse_state.x, mouse_state.y, V);
            al_unlock_bitmap(bmp);

            // draw updated bitmap
            al_draw_bitmap(bmp, 0, 0, 0);

            // draw updated text
            al_draw_text(font, al_map_rgb(0, 0, 0), 0, 0, 0, "Initial velocity: ");
            sprintf(V_stringed, "%f", V);
            al_draw_text(font, al_map_rgb(0, 0, 0), 200, 0, 0, V_stringed);

            // display
            al_flip_display();

            break;

        case ALLEGRO_EVENT_DISPLAY_CLOSE:
            done = true;
            break;
        }
    }

    // deallocate memory
    al_destroy_display(disp);
    al_destroy_event_queue(queue);
    al_destroy_bitmap(bmp);
    al_destroy_font(font);
    free(V_stringed);

    return 0;
}