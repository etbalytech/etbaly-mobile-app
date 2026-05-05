import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BrandPlan } from './brand-plan';

describe('BrandPlan', () => {
  let component: BrandPlan;
  let fixture: ComponentFixture<BrandPlan>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BrandPlan],
    }).compileComponents();

    fixture = TestBed.createComponent(BrandPlan);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
