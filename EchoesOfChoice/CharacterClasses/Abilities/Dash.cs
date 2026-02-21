using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Dash : Ability
    {
        public Dash()
        {
            Name = "Dash";
            FlavorText = "Blur across the battlefield in the blink of an eye. Increases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 1;
        }
    }
}
