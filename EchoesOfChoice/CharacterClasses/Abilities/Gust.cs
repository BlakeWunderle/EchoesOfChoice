using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Gust : Ability
    {
        public Gust()
        {
            Name = "Gust";
            FlavorText = "A fierce gust of wind staggers the enemy, slowing their advance. Decreases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
