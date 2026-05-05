import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Boost } from './boost';

describe('Boost', () => {
  let component: Boost;
  let fixture: ComponentFixture<Boost>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Boost],
    }).compileComponents();

    fixture = TestBed.createComponent(Boost);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
