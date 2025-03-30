import { ComponentFixture, TestBed } from '@angular/core/testing'
import { MessageListComponent  } from './message-list.component'

describe('MessageListComponenet', () => {
    let componenet: MessageListComponent;
    let fixture: ComponentFixture<MessageListComponent>;

    //Setup before each test
    beforeEach(async () => {
        await TestBed.configureTestingModule({
            declarations: [ MessageListComponent ]
        }).compileComponents();

        fixture = TestBed.createComponent(MessageListComponent);
        componenet = fixture.componentInstance;
        fixture.detectChanges();
    });

    //test 1: cmponeent creation
    it('shuld create', () => {
        expect(componenet).toBeTruthy();
    });

    // test 2: cehck input properties
    it('should desplay', () => {
        componenet.title = "Hello";
        fixture.detectChanges();

        const compiled = fixture.nativeElement as HTMLElement;
        expect(compiled.querySelector('h2')?.textContent).toContain('Hello');
    });

    // test 3: Test Button click
    it('should return correct info', () => {
        expect(componenet.onSend()).toBe('Messge Sent!');
    });
})

//run ng test