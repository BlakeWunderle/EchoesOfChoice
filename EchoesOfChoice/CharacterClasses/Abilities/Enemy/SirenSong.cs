using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class SirenSong : Ability
    {
        public SirenSong()
        {
            Name = "Siren Song";
            FlavorText = "An enchanting melody lulls the enemy to sleep. Decreases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
