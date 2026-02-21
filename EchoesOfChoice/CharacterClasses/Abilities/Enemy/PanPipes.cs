using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class PanPipes : Ability
    {
        public PanPipes()
        {
            Name = "Pan Pipes";
            FlavorText = "Mesmerizing music weakens the enemy's resolve. Decreases attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
