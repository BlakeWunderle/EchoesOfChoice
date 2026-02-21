using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class PixieDust : Ability
    {
        public PixieDust()
        {
            Name = "Pixie Dust";
            FlavorText = "Glittering dust clouds the enemy's senses. Decreases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
