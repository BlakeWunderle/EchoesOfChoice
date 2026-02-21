using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Roar : Ability
    {
        public Roar()
        {
            Name = "Roar";
            FlavorText = "A terrifying roar shakes the enemy's resolve. Decreases attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
